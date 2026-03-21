import '../models/quiz.dart';
import '../models/question.dart';

class MockQuizService {
  static List<Quiz> getMockQuizzes() {
    final now = DateTime.now();
    return [
      Quiz(
        uuid: '1',
        title: 'Vocabulary A1',
        description: 'Learn common words',
        category: 'Vocabulary',
        level: 'A1', // 👈 เพิ่ม Level เข้าไป
        points: 10,
        createdAt: now.subtract(const Duration(days: 2)),
        duration: 1, 
        questionCount: 10, 
        tag: 'Part 1',
      ),
      Quiz(
        uuid: '2',
        title: 'Grammar A1',
        description: 'Grammar rules for present tense',
        category: 'Grammar',
        level: 'A1', // 👈 เพิ่ม Level
        points: 10,
        createdAt: now.subtract(const Duration(days: 15)),
        duration: 1, 
        questionCount: 10, 
        tag: 'Part 1',
      ),
      Quiz(
        uuid: '3',
        title: 'Reading A1',
        description: 'Read and answer questions',
        category: 'Reading',
        level: 'A1', // 👈 เพิ่ม Level
        points: 10,
        createdAt: now.subtract(const Duration(days: 45)),
        duration: 1, 
        questionCount: 10, 
        tag: 'Part 1',
      ),
      Quiz(
        uuid: '4',
        title: 'Conversation A1',
        description: 'Practice speaking situations',
        category: 'Conversation',
        level: 'A1', // 👈 ลองให้เป็น A2 บ้าง
        points: 10,
        createdAt: now.subtract(const Duration(days: 5)),
        duration: 1, 
        questionCount: 10, 
        tag: 'Part 1',
      ),
      Quiz(
        uuid: '5',
        title: 'Sentence A2',
        description: 'Building correct sentences',
        category: 'Sentence',
        level: 'A2', // 👈 ลองให้เป็น B1
        points: 10,
        createdAt: now.subtract(const Duration(days: 400)),
        duration: 1, 
        questionCount: 10, 
        tag: 'Part 1',
      ),
      Quiz(
        uuid: '6',
        title: 'Vocabulary A2',
        description: 'Expand your word list',
        category: 'Vocabulary',
        level: 'A2', // 👈 ลองให้เป็น B2
        points: 10,
        createdAt: now.subtract(const Duration(days: 20)),
        duration: 1, 
        questionCount: 10, 
        tag: 'Part 2',
      ),
    ];
  }

  static List<QuizQuestion> getMockQuestionsForQuiz(String quizId) {
    switch (quizId) {
      
      // ==========================================
      // 📦 โหมดแรก: Vocabulary A1 (Part 1)
      // ==========================================
      case '1':
        return [
          QuizQuestion(
            id: 1,
            question: "What is the meaning of 'apple'?",
            explanation: "Apple คือผลไม้",
            choices: [
              QuizChoice(id: 1, text: "A fruit", isCorrect: true),
              QuizChoice(id: 2, text: "A car", isCorrect: false),
              QuizChoice(id: 3, text: "A city", isCorrect: false),
              QuizChoice(id: 4, text: "A job", isCorrect: false),
            ],
          ),
          QuizQuestion(
            id: 2,
            question: "What is the meaning of 'teacher'?",
            explanation: "Teacher คือคนที่สอนนักเรียน",
            choices: [
              QuizChoice(id: 1, text: "A person who teaches students", isCorrect: true),
              QuizChoice(id: 2, text: "A person who cooks food", isCorrect: false),
              QuizChoice(id: 3, text: "A person who drives a bus", isCorrect: false),
              QuizChoice(id: 4, text: "A person who sells clothes", isCorrect: false),
            ],
          ),
          QuizQuestion(
            id: 3,
            question: "Which word means 'large'?",
            explanation: "Big = ใหญ่",
            choices: [
              QuizChoice(id: 1, text: "Small", isCorrect: false),
              QuizChoice(id: 2, text: "Big", isCorrect: true),
              QuizChoice(id: 3, text: "Short", isCorrect: false),
              QuizChoice(id: 4, text: "Low", isCorrect: false),
            ],
          ),
          QuizQuestion(
            id: 4,
            question: "What is the meaning of 'book'?",
            explanation: "Book คือหนังสือ",
            choices: [
              QuizChoice(id: 1, text: "Something you read", isCorrect: true),
              QuizChoice(id: 2, text: "Something you eat", isCorrect: false),
              QuizChoice(id: 3, text: "Something you wear", isCorrect: false),
              QuizChoice(id: 4, text: "Something you drink", isCorrect: false),
            ],
          ),
          QuizQuestion(
            id: 5,
            question: "Which word means 'fast'?",
            explanation: "Quick = เร็ว",
            choices: [
              QuizChoice(id: 1, text: "Quick", isCorrect: true),
              QuizChoice(id: 2, text: "Slow", isCorrect: false),
              QuizChoice(id: 3, text: "Late", isCorrect: false),
              QuizChoice(id: 4, text: "Early", isCorrect: false),
            ],
          ),
          QuizQuestion(
            id: 6,
            question: "What is the meaning of 'dog'?",
            explanation: "Dog คือสัตว์",
            choices: [
              QuizChoice(id: 1, text: "An animal", isCorrect: true),
              QuizChoice(id: 2, text: "A fruit", isCorrect: false),
              QuizChoice(id: 3, text: "A place", isCorrect: false),
              QuizChoice(id: 4, text: "A sport", isCorrect: false),
            ],
          ),
          QuizQuestion(
            id: 7,
            question: "Which word means 'happy'?",
            explanation: "Glad = happy",
            choices: [
              QuizChoice(id: 1, text: "Sad", isCorrect: false),
              QuizChoice(id: 2, text: "Angry", isCorrect: false),
              QuizChoice(id: 3, text: "Glad", isCorrect: true),
              QuizChoice(id: 4, text: "Tired", isCorrect: false),
            ],
          ),
          QuizQuestion(
            id: 8,
            question: "What is the meaning of 'car'?",
            explanation: "Car คือยานพาหนะ",
            choices: [
              QuizChoice(id: 1, text: "A vehicle", isCorrect: true),
              QuizChoice(id: 2, text: "A building", isCorrect: false),
              QuizChoice(id: 3, text: "A job", isCorrect: false),
              QuizChoice(id: 4, text: "A sport", isCorrect: false),
            ],
          ),
          QuizQuestion(
            id: 9,
            question: "Which word means 'begin'?",
            explanation: "Start = begin",
            choices: [
              QuizChoice(id: 1, text: "Start", isCorrect: true),
              QuizChoice(id: 2, text: "Finish", isCorrect: false),
              QuizChoice(id: 3, text: "Stop", isCorrect: false),
              QuizChoice(id: 4, text: "End", isCorrect: false),
            ],
          ),
          QuizQuestion(
            id: 10,
            question: "What is the meaning of 'student'?",
            explanation: "Student คือผู้เรียน",
            choices: [
              QuizChoice(id: 1, text: "A person who studies", isCorrect: true),
              QuizChoice(id: 2, text: "A person who cooks", isCorrect: false),
              QuizChoice(id: 3, text: "A person who sells food", isCorrect: false),
              QuizChoice(id: 4, text: "A person who drives", isCorrect: false),
            ],
          ),
        ];

      // ==========================================
      // 📦 โหมดที่ 2: Grammar A1 (Part 1)
      // ==========================================
      case '2':
        return [
          QuizQuestion(
            id: 11,
            question: "I ___ a student.",
            explanation: "ประธาน 'I' ต้องใช้กับ Verb to be 'am'",
            choices: [
              QuizChoice(id: 1, text: "am", isCorrect: true),
              QuizChoice(id: 2, text: "is", isCorrect: false),
              QuizChoice(id: 3, text: "are", isCorrect: false),
              QuizChoice(id: 4, text: "be", isCorrect: false),
            ],
          ),
          QuizQuestion(
            id: 12,
            question: "She is ___ doctor.",
            explanation: "อาชีพที่มีคนเดียวต้องนำหน้าด้วย 'a'",
            choices: [
              QuizChoice(id: 1, text: "an", isCorrect: false),
              QuizChoice(id: 2, text: "a", isCorrect: true),
              QuizChoice(id: 3, text: "the", isCorrect: false),
              QuizChoice(id: 4, text: "(ไม่มีคำนำหน้า)", isCorrect: false),
            ],
          ),
          QuizQuestion(
            id: 13,
            question: "___ is my brother.",
            explanation: "Brother (พี่ชาย/น้องชาย) เป็นผู้ชาย ต้องใช้ 'He'",
            choices: [
              QuizChoice(id: 1, text: "She", isCorrect: false),
              QuizChoice(id: 2, text: "It", isCorrect: false),
              QuizChoice(id: 3, text: "He", isCorrect: true),
              QuizChoice(id: 4, text: "They", isCorrect: false),
            ],
          ),
          QuizQuestion(
            id: 14,
            question: "They ___ tennis every weekend.",
            explanation: "Present Simple Tense ประธานพหูพจน์ (They) กริยาไม่ต้องเติม s",
            choices: [
              QuizChoice(id: 1, text: "plays", isCorrect: false),
              QuizChoice(id: 2, text: "play", isCorrect: true),
              QuizChoice(id: 3, text: "playing", isCorrect: false),
              QuizChoice(id: 4, text: "played", isCorrect: false),
            ],
          ),
          QuizQuestion(
            id: 15,
            question: "The class starts ___ 8 o'clock.",
            explanation: "การบอกเวลาที่เจาะจงบนหน้าปัดนาฬิกา ต้องใช้ 'at'",
            choices: [
              QuizChoice(id: 1, text: "in", isCorrect: false),
              QuizChoice(id: 2, text: "on", isCorrect: false),
              QuizChoice(id: 3, text: "at", isCorrect: true),
              QuizChoice(id: 4, text: "to", isCorrect: false),
            ],
          ),
          QuizQuestion(
            id: 16,
            question: "This is ___ car. We bought it yesterday.",
            explanation: "รถของพวกเรา (We) ต้องใช้ 'our'",
            choices: [
              QuizChoice(id: 1, text: "my", isCorrect: false),
              QuizChoice(id: 2, text: "their", isCorrect: false),
              QuizChoice(id: 3, text: "his", isCorrect: false),
              QuizChoice(id: 4, text: "our", isCorrect: true),
            ],
          ),
          QuizQuestion(
            id: 17,
            question: "There are two ___ on the table.",
            explanation: "กล่อง 2 ใบ เป็นพหูพจน์ box ต้องเติม es เป็น boxes",
            choices: [
              QuizChoice(id: 1, text: "box", isCorrect: false),
              QuizChoice(id: 2, text: "boxs", isCorrect: false),
              QuizChoice(id: 3, text: "boxes", isCorrect: true),
              QuizChoice(id: 4, text: "boxing", isCorrect: false),
            ],
          ),
          QuizQuestion(
            id: 18,
            question: "___ are my shoes.",
            explanation: "Shoes (รองเท้า) มีสองข้างเป็นพหูพจน์ ต้องใช้ 'These' (เหล่านี้)",
            choices: [
              QuizChoice(id: 1, text: "This", isCorrect: false),
              QuizChoice(id: 2, text: "That", isCorrect: false),
              QuizChoice(id: 3, text: "These", isCorrect: true),
              QuizChoice(id: 4, text: "It", isCorrect: false),
            ],
          ),
          QuizQuestion(
            id: 19,
            question: "Listen! The baby ___.",
            explanation: "มีคำว่า Listen! แสดงว่ากำลังเกิดขึ้น ณ ตอนนี้ ต้องใช้ Present Continuous (is + V.ing)",
            choices: [
              QuizChoice(id: 1, text: "cry", isCorrect: false),
              QuizChoice(id: 2, text: "cries", isCorrect: false),
              QuizChoice(id: 3, text: "crying", isCorrect: false),
              QuizChoice(id: 4, text: "is crying", isCorrect: true),
            ],
          ),
          QuizQuestion(
            id: 20,
            question: "___ are you from?",
            explanation: "ถามว่ามาจาก 'ที่ไหน' ต้องใช้ 'Where'",
            choices: [
              QuizChoice(id: 1, text: "What", isCorrect: false),
              QuizChoice(id: 2, text: "Where", isCorrect: true),
              QuizChoice(id: 3, text: "When", isCorrect: false),
              QuizChoice(id: 4, text: "Who", isCorrect: false),
            ],
          ),
        ];

      // ==========================================
      // 📦 โหมดที่ 3: Reading A1 (Part 1)
      // ==========================================
      case '3':
        return [
          QuizQuestion(
            id: 21,
            question: "Read: 'I have a red car.'\nWhat color is the car?",
            explanation: "ในประโยคระบุชัดเจนว่า 'a red car' (รถสีแดง)",
            choices: [
              QuizChoice(id: 1, text: "Blue", isCorrect: false),
              QuizChoice(id: 2, text: "Red", isCorrect: true),
              QuizChoice(id: 3, text: "Green", isCorrect: false),
              QuizChoice(id: 4, text: "Black", isCorrect: false),
            ],
          ),
          QuizQuestion(
            id: 22,
            question: "Read: 'Anna likes apples, but she doesn't like bananas.'\nWhat does Anna like?",
            explanation: "ประโยคบอกว่า 'Anna likes apples' (แอนนาชอบแอปเปิ้ล)",
            choices: [
              QuizChoice(id: 1, text: "Bananas", isCorrect: false),
              QuizChoice(id: 2, text: "Oranges", isCorrect: false),
              QuizChoice(id: 3, text: "Apples", isCorrect: true),
              QuizChoice(id: 4, text: "Grapes", isCorrect: false),
            ],
          ),
          QuizQuestion(
            id: 23,
            question: "Read: 'The cat is sleeping on the sofa.'\nWhere is the cat?",
            explanation: "'on the sofa' แปลว่า บนโซฟา",
            choices: [
              QuizChoice(id: 1, text: "Under the table", isCorrect: false),
              QuizChoice(id: 2, text: "On the bed", isCorrect: false),
              QuizChoice(id: 3, text: "On the sofa", isCorrect: true),
              QuizChoice(id: 4, text: "In the box", isCorrect: false),
            ],
          ),
          QuizQuestion(
            id: 24,
            question: "Read: 'Tom wakes up at 7:00 AM every day.'\nWhat time does Tom wake up?",
            explanation: "ประโยคบอกเวลาชัดเจนคือ 7:00 AM",
            choices: [
              QuizChoice(id: 1, text: "6:00 AM", isCorrect: false),
              QuizChoice(id: 2, text: "7:00 AM", isCorrect: true),
              QuizChoice(id: 3, text: "8:00 AM", isCorrect: false),
              QuizChoice(id: 4, text: "9:00 AM", isCorrect: false),
            ],
          ),
          QuizQuestion(
            id: 25,
            question: "Read: 'It is raining today. I need an umbrella.'\nWhat is the weather like?",
            explanation: "'It is raining' แปลว่า ฝนกำลังตก",
            choices: [
              QuizChoice(id: 1, text: "Sunny (แดดออก)", isCorrect: false),
              QuizChoice(id: 2, text: "Raining (ฝนตก)", isCorrect: true),
              QuizChoice(id: 3, text: "Snowing (หิมะตก)", isCorrect: false),
              QuizChoice(id: 4, text: "Windy (ลมแรง)", isCorrect: false),
            ],
          ),
          QuizQuestion(
            id: 26,
            question: "Read: 'Sarah has two dogs and one bird.'\nHow many dogs does Sarah have?",
            explanation: "ประโยคบอกว่า 'two dogs' (สุนัข 2 ตัว)",
            choices: [
              QuizChoice(id: 1, text: "One", isCorrect: false),
              QuizChoice(id: 2, text: "Two", isCorrect: true),
              QuizChoice(id: 3, text: "Three", isCorrect: false),
              QuizChoice(id: 4, text: "Four", isCorrect: false),
            ],
          ),
          QuizQuestion(
            id: 27,
            question: "Read: 'The school is next to the park.'\nWhere is the school?",
            explanation: "'next to' แปลว่า ถัดไป หรือ อยู่ติดกับ",
            choices: [
              QuizChoice(id: 1, text: "Behind the park", isCorrect: false),
              QuizChoice(id: 2, text: "In front of the park", isCorrect: false),
              QuizChoice(id: 3, text: "Next to the park", isCorrect: true),
              QuizChoice(id: 4, text: "Under the park", isCorrect: false),
            ],
          ),
          QuizQuestion(
            id: 28,
            question: "Read: 'He goes to work by bus.'\nHow does he go to work?",
            explanation: "'by bus' แปลว่า โดยรถบัส",
            choices: [
              QuizChoice(id: 1, text: "By car", isCorrect: false),
              QuizChoice(id: 2, text: "By train", isCorrect: false),
              QuizChoice(id: 3, text: "By bus", isCorrect: true),
              QuizChoice(id: 4, text: "By bike", isCorrect: false),
            ],
          ),
          QuizQuestion(
            id: 29,
            question: "Read: 'They eat dinner at 6 PM.'\nWhen do they eat dinner?",
            explanation: "Dinner แปลว่าอาหารเย็น และในประโยคบอกว่า 6 PM",
            choices: [
              QuizChoice(id: 1, text: "In the morning", isCorrect: false),
              QuizChoice(id: 2, text: "At 12 PM", isCorrect: false),
              QuizChoice(id: 3, text: "At 6 PM", isCorrect: true),
              QuizChoice(id: 4, text: "At 10 PM", isCorrect: false),
            ],
          ),
          QuizQuestion(
            id: 30,
            question: "Read: 'My favorite color is blue.'\nWhat is the person's favorite color?",
            explanation: "'favorite color' แปลว่า สีที่ชอบ คือ blue (สีฟ้า/น้ำเงิน)",
            choices: [
              QuizChoice(id: 1, text: "Red", isCorrect: false),
              QuizChoice(id: 2, text: "Yellow", isCorrect: false),
              QuizChoice(id: 3, text: "Green", isCorrect: false),
              QuizChoice(id: 4, text: "Blue", isCorrect: true),
            ],
          ),
        ];


      case '4':
        return [
          QuizQuestion(
            id: 31,
            question: "A: 'How are you today?'\nB: '___'",
            explanation: "เมื่อถูกถามว่าสบายดีไหม ควรตอบว่า 'I'm fine, thank you.'",
            choices: [
              QuizChoice(id: 1, text: "I'm 20 years old.", isCorrect: false),
              QuizChoice(id: 2, text: "I'm fine, thank you.", isCorrect: true),
              QuizChoice(id: 3, text: "Yes, I do.", isCorrect: false),
              QuizChoice(id: 4, text: "Nice to meet you.", isCorrect: false),
            ],
          ),
          QuizQuestion(
            id: 32,
            question: "A: 'Nice to meet you.'\nB: '___'",
            explanation: "เมื่อมีคนพูดว่ายินดีที่ได้รู้จัก ควรตอบกลับว่า 'Nice to meet you too.'",
            choices: [
              QuizChoice(id: 1, text: "See you later.", isCorrect: false),
              QuizChoice(id: 2, text: "I'm sorry.", isCorrect: false),
              QuizChoice(id: 3, text: "Thank you.", isCorrect: false),
              QuizChoice(id: 4, text: "Nice to meet you too.", isCorrect: true),
            ],
          ),
          QuizQuestion(
            id: 33,
            question: "A: 'What time is it?'\nB: '___'",
            explanation: "ถามเวลา (What time) ต้องตอบเป็นเวลา เช่น 'It's 10 o'clock.'",
            choices: [
              QuizChoice(id: 1, text: "It's in the bag.", isCorrect: false),
              QuizChoice(id: 2, text: "It's 10 o'clock.", isCorrect: true),
              QuizChoice(id: 3, text: "I have time.", isCorrect: false),
              QuizChoice(id: 4, text: "Yes, it is.", isCorrect: false),
            ],
          ),
          QuizQuestion(
            id: 34,
            question: "A: 'Where is the restroom?'\nB: '___'",
            explanation: "ถามหาสถานที่ (Where) ต้องตอบเป็นตำแหน่ง เช่น 'It's down the hall.' (เดินไปตามทางเดิน)",
            choices: [
              QuizChoice(id: 1, text: "It's at 5 PM.", isCorrect: false),
              QuizChoice(id: 2, text: "It's down the hall.", isCorrect: true),
              QuizChoice(id: 3, text: "Yes, please.", isCorrect: false),
              QuizChoice(id: 4, text: "I like it.", isCorrect: false),
            ],
          ),
          QuizQuestion(
            id: 35,
            question: "A: 'Can I have the menu, please?'\nB: '___'",
            explanation: "เมื่อลูกค้าร้องขอเมนู พนักงานควรยื่นให้พร้อมพูดว่า 'Here you are.' (นี่ครับ/ค่ะ)",
            choices: [
              QuizChoice(id: 1, text: "Here you are.", isCorrect: true),
              QuizChoice(id: 2, text: "No, I can't.", isCorrect: false),
              QuizChoice(id: 3, text: "It's delicious.", isCorrect: false),
              QuizChoice(id: 4, text: "Yes, I do.", isCorrect: false),
            ],
          ),
          QuizQuestion(
            id: 36,
            question: "A: 'How much is this shirt?'\nB: '___'",
            explanation: "ถามราคา (How much) ต้องตอบเป็นจำนวนเงิน",
            choices: [
              QuizChoice(id: 1, text: "It's blue.", isCorrect: false),
              QuizChoice(id: 2, text: "It's a shirt.", isCorrect: false),
              QuizChoice(id: 3, text: "It's 15 dollars.", isCorrect: true),
              QuizChoice(id: 4, text: "It's small.", isCorrect: false),
            ],
          ),
          QuizQuestion(
            id: 37,
            question: "A: 'Do you like coffee?'\nB: '___'",
            explanation: "คำถามขึ้นต้นด้วย Do you... คำตอบรับต้องเป็น 'Yes, I do.' หรือ 'No, I don't.'",
            choices: [
              QuizChoice(id: 1, text: "Yes, I do.", isCorrect: true),
              QuizChoice(id: 2, text: "No, I am not.", isCorrect: false),
              QuizChoice(id: 3, text: "I want tea.", isCorrect: false),
              QuizChoice(id: 4, text: "It is coffee.", isCorrect: false),
            ],
          ),
          QuizQuestion(
            id: 38,
            question: "A: 'What do you do?'\nB: '___'",
            explanation: "คำถาม 'What do you do?' หมายถึงคุณทำงานอะไร (อาชีพ)",
            choices: [
              QuizChoice(id: 1, text: "I am reading.", isCorrect: false),
              QuizChoice(id: 2, text: "I am a teacher.", isCorrect: true),
              QuizChoice(id: 3, text: "I do it.", isCorrect: false),
              QuizChoice(id: 4, text: "Fine, thanks.", isCorrect: false),
            ],
          ),
          QuizQuestion(
            id: 39,
            question: "A: 'Would you like some water?'\nB: '___'",
            explanation: "เมื่อมีคนเสนอสิ่งของให้ ถ้าต้องการรับควรตอบ 'Yes, please.' (ได้ครับ/ค่ะ ขอบคุณ)",
            choices: [
              QuizChoice(id: 1, text: "No, I am not.", isCorrect: false),
              QuizChoice(id: 2, text: "Water is cold.", isCorrect: false),
              QuizChoice(id: 3, text: "Yes, please.", isCorrect: true),
              QuizChoice(id: 4, text: "I like water.", isCorrect: false),
            ],
          ),
          QuizQuestion(
            id: 40,
            question: "A: 'Sorry, I'm late.'\nB: '___'",
            explanation: "เมื่ออีกฝ่ายขอโทษที่มาสาย มารยาทในการตอบรับคือ 'That's all right.' (ไม่เป็นไร)",
            choices: [
              QuizChoice(id: 1, text: "You're welcome.", isCorrect: false),
              QuizChoice(id: 2, text: "That's all right.", isCorrect: true),
              QuizChoice(id: 3, text: "Yes, you are.", isCorrect: false),
              QuizChoice(id: 4, text: "I don't know.", isCorrect: false),
            ],
          ),
        ];



      case '5':
        return [
          QuizQuestion(
            id: 41,
            question: "Choose the correct sentence. (เลือกประโยคที่เรียงถูกต้อง)",
            explanation: "โครงสร้างที่ถูกต้องคือ Subject + Verb + Place + Time (I go to school every day.)",
            choices: [
              QuizChoice(id: 1, text: "I go every day to school.", isCorrect: false),
              QuizChoice(id: 2, text: "I go to school every day.", isCorrect: true),
              QuizChoice(id: 3, text: "Every day go I to school.", isCorrect: false),
              QuizChoice(id: 4, text: "To school I go every day.", isCorrect: false),
            ],
          ),
          QuizQuestion(
            id: 42,
            question: "Choose the correct sentence.",
            explanation: "Adverb of frequency (always, usually) ต้องวาง 'หลัง' Verb to be (is/am/are)",
            choices: [
              QuizChoice(id: 1, text: "She always is late.", isCorrect: false),
              QuizChoice(id: 2, text: "Always she is late.", isCorrect: false),
              QuizChoice(id: 3, text: "She is always late.", isCorrect: true),
              QuizChoice(id: 4, text: "She is late always.", isCorrect: false),
            ],
          ),
          QuizQuestion(
            id: 43,
            question: "I was very tired, ___ I went to bed early.",
            explanation: "'so' (ดังนั้น) ใช้เชื่อมประโยคที่เป็นเหตุเป็นผลกัน",
            choices: [
              QuizChoice(id: 1, text: "because", isCorrect: false),
              QuizChoice(id: 2, text: "but", isCorrect: false),
              QuizChoice(id: 3, text: "so", isCorrect: true),
              QuizChoice(id: 4, text: "or", isCorrect: false),
            ],
          ),
          QuizQuestion(
            id: 44,
            question: "Choose the correct question format.",
            explanation: "การสร้างคำถาม Present Simple ต้องใช้ Wh- + do/does + Subject + V.1",
            choices: [
              QuizChoice(id: 1, text: "Where you live?", isCorrect: false),
              QuizChoice(id: 2, text: "Where do you live?", isCorrect: true),
              QuizChoice(id: 3, text: "Where are you live?", isCorrect: false),
              QuizChoice(id: 4, text: "Where live you?", isCorrect: false),
            ],
          ),
          QuizQuestion(
            id: 45,
            question: "Choose the correct negative sentence.",
            explanation: "Past Simple รูปปฏิเสธต้องใช้ didn't + V.1 (ไม่ผันรูป) คือ didn't go",
            choices: [
              QuizChoice(id: 1, text: "I didn't went to the park.", isCorrect: false),
              QuizChoice(id: 2, text: "I not go to the park.", isCorrect: false),
              QuizChoice(id: 3, text: "I didn't go to the park.", isCorrect: true),
              QuizChoice(id: 4, text: "I don't went to the park.", isCorrect: false),
            ],
          ),
          QuizQuestion(
            id: 46,
            question: "Arrange the words: [taller] [is] [John] [than] [Peter]",
            explanation: "การเปรียบเทียบขั้นกว่า: Subject + is + adj.er + than + Object",
            choices: [
              QuizChoice(id: 1, text: "John is taller than Peter.", isCorrect: true),
              QuizChoice(id: 2, text: "John taller is than Peter.", isCorrect: false),
              QuizChoice(id: 3, text: "Peter is than taller John.", isCorrect: false),
              QuizChoice(id: 4, text: "John is than taller Peter.", isCorrect: false),
            ],
          ),
          QuizQuestion(
            id: 47,
            question: "There ___ a lot of people in the park today.",
            explanation: "'a lot of people' เป็นพหูพจน์ ดังนั้นต้องใช้ 'There are' (มี)",
            choices: [
              QuizChoice(id: 1, text: "is", isCorrect: false),
              QuizChoice(id: 2, text: "are", isCorrect: true),
              QuizChoice(id: 3, text: "has", isCorrect: false),
              QuizChoice(id: 4, text: "have", isCorrect: false),
            ],
          ),
          QuizQuestion(
            id: 48,
            question: "I like playing football, ___ my brother prefers tennis.",
            explanation: "'but' (แต่) ใช้เชื่อมประโยคที่มีความหมายขัดแย้งกัน",
            choices: [
              QuizChoice(id: 1, text: "because", isCorrect: false),
              QuizChoice(id: 2, text: "so", isCorrect: false),
              QuizChoice(id: 3, text: "but", isCorrect: true),
              QuizChoice(id: 4, text: "or", isCorrect: false),
            ],
          ),
          QuizQuestion(
            id: 49,
            question: "My birthday is ___ the 5th of May.",
            explanation: "การระบุวันที่ (Date) ที่มีวันที่เจาะจง ต้องใช้ preposition 'on'",
            choices: [
              QuizChoice(id: 1, text: "in", isCorrect: false),
              QuizChoice(id: 2, text: "on", isCorrect: true),
              QuizChoice(id: 3, text: "at", isCorrect: false),
              QuizChoice(id: 4, text: "by", isCorrect: false),
            ],
          ),
          QuizQuestion(
            id: 50,
            question: "I went to the supermarket ___ some milk.",
            explanation: "การบอกจุดประสงค์ของการกระทำ (เพื่อที่จะ...) ต้องใช้ 'to + V.1' (to buy)",
            choices: [
              QuizChoice(id: 1, text: "for buy", isCorrect: false),
              QuizChoice(id: 2, text: "to buy", isCorrect: true),
              QuizChoice(id: 3, text: "buying", isCorrect: false),
              QuizChoice(id: 4, text: "bought", isCorrect: false),
            ],
          ),
        ];



      case '6':
        return [
          QuizQuestion(
            id: 51,
            question: "What is the opposite of 'expensive'?",
            explanation: "Expensive แปลว่าแพง ตรงข้ามกับ Cheap ที่แปลว่าราคาถูก",
            choices: [
              QuizChoice(id: 1, text: "Rich", isCorrect: false),
              QuizChoice(id: 2, text: "Cheap", isCorrect: true),
              QuizChoice(id: 3, text: "Poor", isCorrect: false),
              QuizChoice(id: 4, text: "Heavy", isCorrect: false),
            ],
          ),
          QuizQuestion(
            id: 52,
            question: "A place where you can borrow books is a ___.",
            explanation: "สถานที่ยืมหนังสือคือ Library (ห้องสมุด)",
            choices: [
              QuizChoice(id: 1, text: "Hospital", isCorrect: false),
              QuizChoice(id: 2, text: "Supermarket", isCorrect: false),
              QuizChoice(id: 3, text: "Museum", isCorrect: false),
              QuizChoice(id: 4, text: "Library", isCorrect: true),
            ],
          ),
          QuizQuestion(
            id: 53,
            question: "Which word means 'very tired'?",
            explanation: "Exhausted แปลว่าเหนื่อยล้ามากๆ (Very tired)",
            choices: [
              QuizChoice(id: 1, text: "Exhausted", isCorrect: true),
              QuizChoice(id: 2, text: "Excited", isCorrect: false),
              QuizChoice(id: 3, text: "Bored", isCorrect: false),
              QuizChoice(id: 4, text: "Hungry", isCorrect: false),
            ],
          ),
          QuizQuestion(
            id: 54,
            question: "You go to a ___ to buy medicine.",
            explanation: "Medicine คือยา สถานที่ซื้อยาคือ Pharmacy (ร้านขายยา)",
            choices: [
              QuizChoice(id: 1, text: "Bakery", isCorrect: false),
              QuizChoice(id: 2, text: "Pharmacy", isCorrect: true),
              QuizChoice(id: 3, text: "Bank", isCorrect: false),
              QuizChoice(id: 4, text: "Post office", isCorrect: false),
            ],
          ),
          QuizQuestion(
            id: 55,
            question: "What do you use to cut paper?",
            explanation: "อุปกรณ์ที่ใช้ตัดกระดาษคือ Scissors (กรรไกร)",
            choices: [
              QuizChoice(id: 1, text: "Spoon", isCorrect: false),
              QuizChoice(id: 2, text: "Fork", isCorrect: false),
              QuizChoice(id: 3, text: "Scissors", isCorrect: true),
              QuizChoice(id: 4, text: "Pencil", isCorrect: false),
            ],
          ),
          QuizQuestion(
            id: 56,
            question: "The meal you eat in the middle of the day is ___.",
            explanation: "มื้ออาหารตอนกลางวันเรียกว่า Lunch",
            choices: [
              QuizChoice(id: 1, text: "Breakfast", isCorrect: false),
              QuizChoice(id: 2, text: "Dinner", isCorrect: false),
              QuizChoice(id: 3, text: "Snack", isCorrect: false),
              QuizChoice(id: 4, text: "Lunch", isCorrect: true),
            ],
          ),
          QuizQuestion(
            id: 57,
            question: "What is the opposite of 'heavy'?",
            explanation: "Heavy แปลว่าหนัก ตรงข้ามกับ Light ที่แปลว่าเบา",
            choices: [
              QuizChoice(id: 1, text: "Dark", isCorrect: false),
              QuizChoice(id: 2, text: "Light", isCorrect: true),
              QuizChoice(id: 3, text: "Strong", isCorrect: false),
              QuizChoice(id: 4, text: "Tall", isCorrect: false),
            ],
          ),
          QuizQuestion(
            id: 58,
            question: "You wear these on your feet inside your shoes.",
            explanation: "สิ่งที่เราใส่ไว้ในรองเท้าคือ Socks (ถุงเท้า)",
            choices: [
              QuizChoice(id: 1, text: "Gloves", isCorrect: false),
              QuizChoice(id: 2, text: "Hats", isCorrect: false),
              QuizChoice(id: 3, text: "Socks", isCorrect: true),
              QuizChoice(id: 4, text: "Belts", isCorrect: false),
            ],
          ),
          QuizQuestion(
            id: 59,
            question: "A machine that keeps food cold is a ___.",
            explanation: "เครื่องใช้ไฟฟ้าที่ทำให้อาหารเย็นคือ Fridge (ตู้เย็น)",
            choices: [
              QuizChoice(id: 1, text: "Oven", isCorrect: false),
              QuizChoice(id: 2, text: "Washing machine", isCorrect: false),
              QuizChoice(id: 3, text: "Television", isCorrect: false),
              QuizChoice(id: 4, text: "Fridge", isCorrect: true),
            ],
          ),
          QuizQuestion(
            id: 60,
            question: "The day after Tuesday is ___.",
            explanation: "วันถัดจากวันอังคาร (Tuesday) คือวันพุธ (Wednesday)",
            choices: [
              QuizChoice(id: 1, text: "Monday", isCorrect: false),
              QuizChoice(id: 2, text: "Wednesday", isCorrect: true),
              QuizChoice(id: 3, text: "Thursday", isCorrect: false),
              QuizChoice(id: 4, text: "Friday", isCorrect: false),
            ],
          ),
        ];

      // ==========================================
      // กรณีหาไม่เจอ (ป้องกันแอปเด้ง)
      // ==========================================
      default:
        return [];
    }
  }
}