import { db } from '../src/db/index.js';
import * as schema from '../src/db/schema.js';
import { readFile } from 'fs/promises';
import path from 'path';
import { fileURLToPath } from 'url';

const __filename = fileURLToPath(import.meta.url);
const __dirname = path.dirname(__filename);

async function reseedShelter() {
  console.log('Clearing old shelters...');
  await db.delete(schema.donation);
  await db.delete(schema.shelter);
  
  console.log('Reading shelter.json...');
  const shelterData = JSON.parse(
    await readFile(path.join(__dirname, 'data', 'shelter.json'), 'utf-8')
  );
  
  console.log(`Inserting ${shelterData.length} new shelters...`);
  const mappedShelterData = shelterData.map((s: any) => {
    const { image, ...rest } = s;
    return { ...rest, shelterImage: image };
  });
  
  await db.insert(schema.shelter).values(mappedShelterData);
  console.log('✅ Reseed complete!');
  process.exit(0);
}

reseedShelter().catch(e => {
  console.error(e);
  process.exit(1);
});
