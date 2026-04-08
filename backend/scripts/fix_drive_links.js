import fs from 'fs';
import path from 'path';
import { fileURLToPath } from 'url';

const __filename = fileURLToPath(import.meta.url);
const __dirname = path.dirname(__filename);

const filePath = path.join(__dirname, 'data', 'quiz_seed_data.json');
let content = fs.readFileSync(filePath, 'utf-8');

// ใช้ Regex หา Google Drive ID จาก /view?usp=sharing และ /view?usp=share_link
const regex = /https:\/\/drive\.google\.com\/file\/d\/([a-zA-Z0-9_-]+)\/view\?usp=share_link|https:\/\/drive\.google\.com\/file\/d\/([a-zA-Z0-9_-]+)\/view\?usp=sharing/g;

content = content.replace(regex, (match, p1, p2) => {
    const id = p1 || p2;
    return `https://drive.google.com/uc?export=view&id=${id}`;
});

fs.writeFileSync(filePath, content, 'utf-8');
console.log('✅ แปลงลิงก์ Google Drive ในไฟล์ quiz_seed_data.json เป็น Direct Link เรียบร้อยแล้ว!');
