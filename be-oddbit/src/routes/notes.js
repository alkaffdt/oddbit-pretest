const express = require('express');
const pool = require('../db');
const authMiddleware = require('../middleware/authMiddleware');

const router = express.Router();

// Apply middleware to all routes in this router
router.use(authMiddleware);

// GET /api/notes - Ambil semua notes milik user yang login
router.get('/', async (req, res) => {
    try {
        const userId = req.user.id;
        const result = await pool.query(
            'SELECT * FROM notes WHERE user_id = $1 ORDER BY created_at DESC',
            [userId]
        );
        res.json(result.rows);
    } catch (err) {
        console.error('Error getting notes:', err);
        res.status(500).json({ error: 'Internal server error' });
    }
});

// POST /api/notes - Create a new note (title + content)
router.post('/', async (req, res) => {
    try {
        const userId = req.user.id;
        const { title, content } = req.body;

        if (!title) {
            return res.status(400).json({ error: 'Title is required' });
        }

        const result = await pool.query(
            'INSERT INTO notes (user_id, title, content) VALUES ($1, $2, $3) RETURNING *',
            [userId, title, content]
        );

        res.status(201).json(result.rows[0]);
    } catch (err) {
        console.error('Error creating note:', err);
        res.status(500).json({ error: 'Internal server error' });
    }
});

// PUT /api/notes/{id} - Update a note
router.put('/:id', async (req, res) => {
    try {
        const userId = req.user.id;
        const noteId = req.params.id;
        const { title, content } = req.body;

        if (!title) {
            return res.status(400).json({ error: 'Title is required' });
        }

        // Ensure the note exists and belongs to the user
        const result = await pool.query(
            'UPDATE notes SET title = $1, content = $2 WHERE id = $3 AND user_id = $4 RETURNING *',
            [title, content, noteId, userId]
        );

        if (result.rows.length === 0) {
            return res.status(404).json({ error: 'Note not found or unauthorized' });
        }

        res.json(result.rows[0]);
    } catch (err) {
        console.error('Error updating note:', err);
        res.status(500).json({ error: 'Internal server error' });
    }
});

// DELETE /api/notes/{id} - Delete a note
router.delete('/:id', async (req, res) => {
    try {
        const userId = req.user.id;
        const noteId = req.params.id;

        // Ensure the note exists and belongs to the user
        const result = await pool.query(
            'DELETE FROM notes WHERE id = $1 AND user_id = $2 RETURNING *',
            [noteId, userId]
        );

        if (result.rows.length === 0) {
            return res.status(404).json({ error: 'Note not found or unauthorized' });
        }

        res.json({ message: 'Note deleted successfully', note: result.rows[0] });
    } catch (err) {
        console.error('Error deleting note:', err);
        res.status(500).json({ error: 'Internal server error' });
    }
});

module.exports = router;
