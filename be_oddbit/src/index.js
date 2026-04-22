require('dotenv').config();
const express = require('express');
const swaggerUi = require('swagger-ui-express');
const swaggerSpec = require('./swagger');
const authRoutes = require('./routes/auth');
const notesRoutes = require('./routes/notes');
const pool = require('./db');

const app = express();

// Middleware to parse JSON bodies
app.use(express.json());

// Swagger UI
app.use('/api-docs', swaggerUi.serve, swaggerUi.setup(swaggerSpec, {
    customSiteTitle: 'Oddbit Notes API',
    swaggerOptions: {
        persistAuthorization: true,
    },
}));

// JSON spec endpoint (useful for importing into Postman, etc.)
app.get('/api-docs.json', (req, res) => {
    res.setHeader('Content-Type', 'application/json');
    res.send(swaggerSpec);
});

// Main Routes
app.use('/api/auth', authRoutes);
app.use('/api/notes', notesRoutes);

// Health check endpoint
app.get('/health', (req, res) => {
    res.json({ status: 'OK' });
});

// Specific error handling for malformed JSON
app.use((err, req, res, next) => {
    if (err instanceof SyntaxError && err.status === 400 && 'body' in err) {
        return res.status(400).send({ error: 'Malformed JSON' });
    }
    next(err);
});

async function runMigrations() {
    try {
        await pool.query(`
            ALTER TABLE users ADD COLUMN IF NOT EXISTS refresh_token TEXT;
        `);
        console.log('Migrations applied successfully.');
    } catch (err) {
        console.error('Migration error:', err.message);
    }
}

const PORT = process.env.PORT || 3000;

runMigrations().then(() => {
    app.listen(PORT, '0.0.0.0', () => {
        console.log(`Server is running on port ${PORT}`);
        console.log(`Swagger docs available at http://localhost:${PORT}/api-docs`);
    });
});
