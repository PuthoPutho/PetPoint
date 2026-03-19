import { db } from '../src/db/index.js';
import * as schema from '../src/db/schema.js';

async function deleteData() {
  console.log('🗑️ Deleting all data from database...');

  try {
    // Order matters for deletion if cascade isn't fully relied upon
    // though schema has onDelete: 'cascade' for relationship links

    console.log('Clearing score_history...');
    await db.delete(schema.score_history);

    console.log('Clearing quiz_history...');
    await db.delete(schema.quiz_history);

    console.log('Clearing donation...');
    await db.delete(schema.donation);

    console.log('Clearing choices...');
    await db.delete(schema.choices);

    console.log('Clearing questions...');
    await db.delete(schema.questions);

    console.log('Clearing quiz...');
    await db.delete(schema.quiz);

    console.log('Clearing shelter...');
    await db.delete(schema.shelter);

    console.log('Clearing users...');
    await db.delete(schema.user);

    console.log('✅ Data deletion completed successfully!');
    process.exit(0);
  } catch (error) {
    console.error('❌ Deletion failed:', error);
    process.exit(1);
  }
}

deleteData();
