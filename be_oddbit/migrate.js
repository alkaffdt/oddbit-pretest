require('dotenv').config();
const { Client } = require('pg');
const fs = require('fs');
const path = require('path');

const client = new Client({
    connectionString: process.env.DATABASE_URL
});

async function runMigration() {
    try {
        await client.connect();
        console.log('Connected to the database. Running migration...');
        
        const schemaPath = path.join(__dirname, 'schema.sql');
        const schemaQuery = fs.readFileSync(schemaPath, 'utf8');
        
        await client.query(schemaQuery);
        console.log('Migration completed successfully. Tables created.');
        
    } catch (err) {
        console.error('Error running migration:', err);
    } finally {
        await client.end();
    }
}

runMigration();
