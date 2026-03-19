import { db } from '../src/db/index.js';
import * as schema from '../src/db/schema.js';
import { readFile } from 'fs/promises';
import { fileURLToPath } from 'url';
import path from 'path';

const __filename = fileURLToPath(import.meta.url);
const __dirname = path.dirname(__filename);

async function seed() {
  console.log('🌱 Seeding database...');

  try {
    // 1. Seed Quizzes
    const quizData = JSON.parse(
      await readFile(path.join(__dirname, 'data', 'quiz.json'), 'utf-8')
    );
    console.log(`Inserting ${quizData.length} quizzes...`);
    const insertedQuizzes = [];
    for (const q of quizData) {
        // Map 'image' to 'quizImage' if needed
        const { image, ...rest } = q;
        const [inserted] = await db.insert(schema.quiz)
            .values({ ...rest, quizImage: image })
            .returning();
        insertedQuizzes.push(inserted);
    }

    // 2. Seed Shelters
    const shelterData = JSON.parse(
      await readFile(path.join(__dirname, 'data', 'shelter.json'), 'utf-8')
    );
    console.log(`Inserting ${shelterData.length} shelters...`);
    // Map 'image' to 'shelterImage'
    const mappedShelterData = shelterData.map((s: any) => {
        const { image, ...rest } = s;
        return { ...rest, shelterImage: image };
    });
    await db.insert(schema.shelter).values(mappedShelterData);

    // 3. Seed Questions and Choices
    const questionData = JSON.parse(
      await readFile(path.join(__dirname, 'data', 'question.json'), 'utf-8')
    );
    
    console.log(`Inserting ${questionData.length} questions and their choices...`);
    
    for (const q of questionData) {
      const { choices, ...questionPart } = q;
      
      // Use the first quiz for all questions for now
      const quizId = insertedQuizzes[0].uuid;
      
      // Insert question and get the result (uuid)
      const [insertedQuestion] = await db.insert(schema.questions)
        .values({ ...questionPart, quizId })
        .returning({ uuid: schema.questions.uuid });
      
      if (insertedQuestion) {
        // Map choices to include the questionId
        const choicesWithId = choices.map((c: any) => ({
          ...c,
          questionId: insertedQuestion.uuid
        }));
        
        await db.insert(schema.choices).values(choicesWithId);
      }
    }

    console.log('✅ Seeding completed successfully!');
    process.exit(0);
  } catch (error) {
    console.error('❌ Seeding failed:', error);
    process.exit(1);
  }
}

seed();
