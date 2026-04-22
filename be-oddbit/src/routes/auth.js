const express = require('express');
const bcrypt = require('bcrypt');
const jwt = require('jsonwebtoken');
const pool = require('../db');

const router = express.Router();

const JWT_SECRET = process.env.JWT_SECRET || 'fallback_secret_keep_secret_in_prod';
const REFRESH_SECRET = process.env.REFRESH_TOKEN_SECRET || 'fallback_refresh_secret_keep_secret_in_prod';

const generateAccessToken = (user) => {
    return jwt.sign(
        { id: user.id, username: user.username },
        JWT_SECRET,
        { expiresIn: '15m' }
    );
};

const generateRefreshToken = (user) => {
    return jwt.sign(
        { id: user.id, username: user.username },
        REFRESH_SECRET,
        { expiresIn: '7d' }
    );
};

router.post('/register', async (req, res) => {
    try {
        const { username, password } = req.body || {};

        if (!username || !password) {
            return res.status(400).json({ error: 'Username and password are required' });
        }

        // Check if user exists
        const userCheck = await pool.query('SELECT id FROM users WHERE username = $1', [username]);
        if (userCheck.rows.length > 0) {
            return res.status(409).json({ error: 'Username already exists' });
        }

        // Hash password
        const saltRounds = 10;
        const passwordHash = await bcrypt.hash(password, saltRounds);

        // Generate tokens first
        const dummyUser = { username }; // Temporary for token generation if ID not yet known, but we need ID
        
        // Insert new user
        const result = await pool.query(
            'INSERT INTO users (username, password_hash) VALUES ($1, $2) RETURNING id, username, created_at',
            [username, passwordHash]
        );

        const newUser = result.rows[0];

        // Generate tokens
        const accessToken = generateAccessToken(newUser);
        const refreshToken = generateRefreshToken(newUser);

        // Store refresh token in DB
        await pool.query('UPDATE users SET refresh_token = $1 WHERE id = $2', [refreshToken, newUser.id]);

        res.status(201).json({ 
            message: 'User registered successfully', 
            user: { id: newUser.id, username: newUser.username, created_at: newUser.created_at },
            access_token: accessToken,
            refresh_token: refreshToken
        });

    } catch (err) {
        console.error('Error in register:', err);
        res.status(500).json({ error: 'Internal server error' });
    }
});

router.post('/login', async (req, res) => {
    try {
        const { username, password } = req.body || {};

        if (!username || !password) {
            return res.status(400).json({ error: 'Username and password are required' });
        }

        // Fetch user
        const result = await pool.query('SELECT * FROM users WHERE username = $1', [username]);
        if (result.rows.length === 0) {
            return res.status(401).json({ error: 'Invalid credentials' });
        }

        const user = result.rows[0];

        // Compare password
        const match = await bcrypt.compare(password, user.password_hash);
        if (!match) {
            return res.status(401).json({ error: 'Invalid credentials' });
        }

        // Generate tokens
        const accessToken = generateAccessToken(user);
        const refreshToken = generateRefreshToken(user);

        // Update refresh token in DB
        await pool.query('UPDATE users SET refresh_token = $1 WHERE id = $2', [refreshToken, user.id]);

        res.json({ 
            message: 'Login successful', 
            access_token: accessToken, 
            refresh_token: refreshToken,
            username: user.username 
        });

    } catch (err) {
        console.error('Error in login:', err);
        res.status(500).json({ error: 'Internal server error' });
    }
});

router.post('/refresh', async (req, res) => {
    try {
        const { refresh_token } = req.body;

        if (!refresh_token) {
            return res.status(401).json({ error: 'Refresh token is required' });
        }

        // Verify token
        let payload;
        try {
            payload = jwt.verify(refresh_token, process.env.REFRESH_TOKEN_SECRET);
        } catch (err) {
            return res.status(403).json({ error: 'Invalid or expired refresh token' });
        }

        // Check if token exists in DB
        const result = await pool.query('SELECT * FROM users WHERE id = $1 AND refresh_token = $2', [payload.id, refresh_token]);
        
        if (result.rows.length === 0) {
            return res.status(403).json({ error: 'Invalid refresh token' });
        }

        const user = result.rows[0];

        // Generate new tokens
        const newAccessToken = generateAccessToken(user);
        const newRefreshToken = generateRefreshToken(user);

        // Update refresh token in DB (Refresh Token Rotation)
        await pool.query('UPDATE users SET refresh_token = $1 WHERE id = $2', [newRefreshToken, user.id]);

        res.json({
            access_token: newAccessToken,
            refresh_token: newRefreshToken
        });

    } catch (err) {
        console.error('Error in refresh:', err);
        res.status(500).json({ error: 'Internal server error' });
    }
});

router.post('/logout', async (req, res) => {
    try {
        const { refresh_token } = req.body;
        
        if (refresh_token) {
            // Remove refresh token from DB
            await pool.query('UPDATE users SET refresh_token = NULL WHERE refresh_token = $1', [refresh_token]);
        }
        
        res.json({ message: 'Logged out successfully' });
    } catch (err) {
        console.error('Error in logout:', err);
        res.status(500).json({ error: 'Internal server error' });
    }
});

module.exports = router;
