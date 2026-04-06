import { db } from '../src/db/index.js';
import * as schema from '../src/db/schema.js';
import { readFile } from 'fs/promises';
import { fileURLToPath } from 'url';
import path from 'path';
import bcrypt from 'bcryptjs';

const __filename = fileURLToPath(import.meta.url);
const __dirname = path.dirname(__filename);

async function seed() {
  console.log('🌱 Seeding database...');

  try {
    // 1. อ่านไฟล์ quiz_seed_data.json
    const quizData = JSON.parse(
      await readFile(path.join(__dirname, 'data', 'quiz_seed_data.json'), 'utf-8')
    );
    console.log(`Inserting ${quizData.length} quizzes...`);

    // วนลูปทีละควิซ
    for (const q of quizData) {
      // 🌟 ดักจับรูปภาพ: ถ้าใน JSON ไม่มีรูปเลย ให้ใช้รูปลูกหมา/แมวตั้งต้นแทน ห้ามเป็น null เด็ดขาด!
      const coverImage = q.quizImage || q.imageUrl || q.image || 'https://images.unsplash.com/photo-1548191265-cc70d3d45ba1';

      // 🌟 1.1 Insert ควิซลง Database (จับยัดทีละฟิลด์ ชัวร์ที่สุด)
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

      console.log(`✅ เพิ่มควิซ: ${insertedQuiz.title}`);

      // 1.2 วนลูป Insert คำถามและช้อยส์
      if (q.questions && q.questions.length > 0) {
        for (const qBody of q.questions) {
          const [insertedQuestion] = await db.insert(schema.questions)
            .values({ 
              quizId: insertedQuiz.uuid,
              question: qBody.question,
              explanation: qBody.explanation
            })
            .returning();

          // เตรียมข้อมูล Choices
          const choicesWithId = qBody.choices.map((c: any) => ({
            questionId: insertedQuestion.uuid,
            choices: c.text,
            isCorrect: c.isCorrect
          }));

          // Insert Choices
          await db.insert(schema.choices).values(choicesWithId);
        }
      }
    }

    // 2. Seed Shelters (ถ้ามีไฟล์ shelter.json)
    try {
      const shelterData = JSON.parse(
        await readFile(path.join(__dirname, 'data', 'shelter.json'), 'utf-8')
      );
      console.log(`Inserting ${shelterData.length} shelters...`);
      const mappedShelterData = shelterData.map((s: any) => {
        const { image, ...rest } = s;
        return { ...rest, shelterImage: image };
      });
      await db.insert(schema.shelter).values(mappedShelterData);
      console.log('✅ เพิ่ม Shelters สำเร็จ');
    } catch (err) {
      console.log('⚠️ ไม่พบไฟล์ shelter.json ข้ามการ Seed ฝั่ง Shelter ไปก่อน');
    }

    console.log('✅ Seeding completed successfully!');
    // 2. Seed Shelters (ถ้ามีไฟล์ shelter.json)
    try {
      const shelterData = JSON.parse(
        await readFile(path.join(__dirname, 'data', 'shelter.json'), 'utf-8')
      );
      console.log(`Inserting ${shelterData.length} shelters...`);
      const mappedShelterData = shelterData.map((s: any) => {
        const { image, ...rest } = s;
        return { ...rest, shelterImage: image };
      });
      await db.insert(schema.shelter).values(mappedShelterData);
      console.log('✅ เพิ่ม Shelters สำเร็จ');
    } catch (err) {
      console.log('⚠️ ไม่พบไฟล์ shelter.json ข้ามการ Seed ฝั่ง Shelter ไปก่อน');
    }

    // 3. Seed Users 
    try {
      const userData = JSON.parse(
        await readFile(path.join(__dirname, 'data', 'user.json'), 'utf-8')
      );
      console.log(`Inserting ${userData.length} users...`);

      const salt = await bcrypt.genSalt(10);
      const usersToInsert = [];

      for (const u of userData) {
        const hashedPassword = await bcrypt.hash(u.password, salt);
        
        usersToInsert.push({
          username: u.username,
          email: u.email,
          password: hashedPassword,
          provider: u.provider || 'local',
          currentScore: u.currentScore || 0,
          equippedPet: u.equippedPet || 'cat_orange',
          profileImage: u.profileImage || null
        });
      }

      await db.insert(schema.user).values(usersToInsert);
      console.log('✅ เพิ่ม Users สำเร็จ');
    } catch (err) {
      console.log('⚠️ ไม่พบไฟล์ user.json ข้ามการ Seed ฝั่ง User ไปก่อน');
    }

    console.log('🎉 Seeding completed successfully!');

    

    process.exit(0);
  } catch (error) {
    console.error('❌ Seeding failed:', error);
    process.exit(1);
  }
}

seed();