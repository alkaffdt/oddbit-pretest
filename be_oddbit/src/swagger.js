const swaggerJsdoc = require('swagger-jsdoc');

const options = {
    definition: {
        openapi: '3.0.0',
        info: {
            title: 'Oddbit Notes API',
            version: '1.0.0',
            description: 'REST API for user authentication and notes management. Access tokens expire in 15 minutes — use the /auth/refresh endpoint to obtain a new pair.',
        },
        servers: [
            {
                url: '/api',
                description: 'API base path',
            },
        ],
        components: {
            securitySchemes: {
                BearerAuth: {
                    type: 'http',
                    scheme: 'bearer',
                    bearerFormat: 'JWT',
                    description: 'Enter your **access_token** here (without "Bearer " prefix — Swagger adds it automatically).',
                },
            },
            schemas: {
                AuthCredentials: {
                    type: 'object',
                    required: ['username', 'password'],
                    properties: {
                        username: { type: 'string', example: 'johndoe' },
                        password: { type: 'string', format: 'password', example: 'mypassword123' },
                    },
                },
                AuthResponse: {
                    type: 'object',
                    properties: {
                        message: { type: 'string', example: 'Login successful' },
                        access_token: { type: 'string', description: 'JWT access token (expires in 15 min)' },
                        refresh_token: { type: 'string', description: 'JWT refresh token (expires in 7 days)' },
                        username: { type: 'string', example: 'johndoe' },
                    },
                },
                RegisterResponse: {
                    type: 'object',
                    properties: {
                        message: { type: 'string', example: 'User registered successfully' },
                        username: { type: 'string', example: 'johndoe' },
                        access_token: { type: 'string' },
                        refresh_token: { type: 'string' },
                    },
                },
                RefreshRequest: {
                    type: 'object',
                    required: ['refresh_token'],
                    properties: {
                        refresh_token: { type: 'string', description: 'A valid, non-expired refresh token' },
                    },
                },
                RefreshResponse: {
                    type: 'object',
                    properties: {
                        access_token: { type: 'string' },
                        refresh_token: { type: 'string', description: 'New refresh token (old one is invalidated)' },
                    },
                },
                Note: {
                    type: 'object',
                    properties: {
                        id: { type: 'integer', example: 1 },
                        user_id: { type: 'integer', example: 1 },
                        title: { type: 'string', example: 'My first note' },
                        content: { type: 'string', example: 'Note content here...' },
                        created_at: { type: 'string', format: 'date-time' },
                    },
                },
                NoteInput: {
                    type: 'object',
                    required: ['title'],
                    properties: {
                        title: { type: 'string', example: 'My note title' },
                        content: { type: 'string', example: 'Optional note body' },
                    },
                },
                Error: {
                    type: 'object',
                    properties: {
                        error: { type: 'string', example: 'Error message here' },
                    },
                },
            },
        },
    },
    apis: ['./src/routes/*.js'],
};

const swaggerSpec = swaggerJsdoc(options);

module.exports = swaggerSpec;
