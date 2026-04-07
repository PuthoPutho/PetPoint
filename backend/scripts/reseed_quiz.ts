import { db } from '../src/db/index.js';
import * as schema from '../src/db/schema.js';
import { readFile } from 'fs/promises';
import { fileURLToPath } from 'url';
import path from 'path';

const __filename = fileURLToPath(import.meta.url);
const __dirname = path.dirname(__filename);

async function reseedQuiz() {
  console.log('🗑️ กำลังลบข้อมูลควิซเก่าออกจากฐานข้อมูล...');
  
  try {
    // ลบข้อมูลที่ผูกกับตาราง quiz ก่อน
    await db.delete(schema.quiz_history);
    await db.delete(schema.quiz_attempts);
    await db.delete(schema.choices);
    await db.delete(schema.questions);
    
    // จากนั้นจึงลบตารางหลัก
    await db.delete(schema.quiz);
    console.log('✅ ลบข้อมูลควิซเก่าสำเร็จ!');

    console.log('🌱 กำลังดึงข้อมูลจาก quiz_seed_data.json เพื่อบันทึกใหม่...');
    const quizData = JSON.parse(
      await readFile(path.join(__dirname, 'data', 'quiz_seed_data.json'), 'utf-8')
    );
    
    console.log(`พบจำนวนควิซทั้งหมด ${quizData.length} หัวข้อ, กำลังเพิ่มลงฐานข้อมูล...`);

    for (const q of quizData) {
      // ใช้ภาพตั้งต้นถ้าไม่มี
      const coverImage = q.quizImage || q.imageUrl || q.image || 'https://images.unsplash.com/photo-1548191265-cc70d3d45ba1';

      // เพิ่มเนื้อหาควิซ
      const [insertedQuiz] = await db.insert(schema.quiz)
        .values({ 
          title: q.title,
          description: q.description,
          category: q.category,
          level: q.level,
          points: q.points || 10,
          duration: q.duration || 100,
          tag: q.tag || 1,
          quizImage: coverImage 
        })
        .returning();

      console.log(`  ➕ เพิ่มควิซ: ${insertedQuiz.title}`);

      // เพิ่มคำถามและตัวเลือก (Choices)
      if (q.questions && q.questions.length > 0) {
        for (const qBody of q.questions) {
          const [insertedQuestion] = await db.insert(schema.questions)
            .values({ 
              quizId: insertedQuiz.uuid,
              question: qBody.question,
              explanation: qBody.explanation
            })
            .returning();

          const choicesWithId = qBody.choices.map((c: any) => ({
            questionId: insertedQuestion.uuid,
            choices: c.text,
            isCorrect: c.isCorrect
          }));

          await db.insert(schema.choices).values(choicesWithId);
        }
      }
    }
    
    console.log('🎉 อัปเดตข้อมูลควิซลงฐานข้อมูลสำเร็จร้อยเปอร์เซ็นต์!');
    process.exit(0);

  } catch (error) {
    console.error('❌ เกิดข้อผิดพลาดในการอัปเดตข้อมูลควิซ:', error);
    process.exit(1);
  }
}

reseedQuiz();
