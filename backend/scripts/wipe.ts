import { db } from '../src/db/index.js';
import pg from 'pg';
import dotenv from 'dotenv';

dotenv.config();

async function wipe() {
  console.log('🚮 Wiping database...');

  const pool = new pg.Pool({
    connectionString: process.env.DATABASE_URL,
  });

  try {
    const client = await pool.connect();
    
    // Get all tables in public schema
    const res = await client.query(`
      SELECT table_name 
      FROM information_schema.tables 
      WHERE table_schema = 'public' AND table_type = 'BASE TABLE';
    `);

    const tables = res.rows.map(row => row.table_name);

    if (tables.length > 0) {
      console.log(`Dropping tables: ${tables.join(', ')}`);
      // Use CASCADE to drop tables with dependencies
      await client.query(`DROP TABLE IF EXISTS "${tables.join('", "')}" CASCADE`);
    } else {
      console.log('No tables found to drop.');
    }

    client.release();
    console.log('✅ Database wiped successfully!');
    process.exit(0);
  } catch (error) {
    console.error('❌ Wipe failed:', error);
    process.exit(1);
  } finally {
    await pool.end();
  }
}

wipe();
