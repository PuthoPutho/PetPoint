// ไฟล์: src/routes/profile.routes.ts
import { Router } from 'express';
import multer from 'multer';
import path from 'path';
import { ProfileService } from '../services/profile.service.js';

export const profileRouter = Router(); // 🌟 เปลี่ยนชื่อเป็น profileRouter

// เรียกใช้งาน Service (ผู้จัดการ)
const profileService = new ProfileService();

// ==========================================
// 1. ตั้งค่า Multer (เหมือนเดิม 100% ไม่หล่นหาย)
// ==========================================
const storage = multer.diskStorage({
    destination: function (req, file, cb) {
        cb(null, 'uploads/'); // เซฟไฟล์ลงโฟลเดอร์ uploads/
    },
    filename: function (req, file, cb) {
        // ตั้งชื่อไฟล์ใหม่ไม่ให้ซ้ำกัน
        const uniqueSuffix = Date.now() + '-' + Math.round(Math.random() * 1E9);
        cb(null, uniqueSuffix + path.extname(file.originalname));
    }
});
const upload = multer({ storage: storage });

// ==========================================
// 2. API Routes (สั้นและสะอาดขึ้นมาก)
// ==========================================

// GET /:userId -> ดึงข้อมูลโปรไฟล์
profileRouter.get('/:userId', async (req, res) => {
    try {
        const { userId } = req.params;
        const foundUser = await profileService.getProfile(String(userId));

        if (!foundUser) {
            res.status(404).json({ success: false, message: 'ไม่พบผู้ใช้นี้' });
            return;
        }
        res.status(200).json({ success: true, data: foundUser });
    } catch (error) {
        res.status(500).json({ success: false, message: 'เซิร์ฟเวอร์ขัดข้อง' });
    }
});

// PUT /:userId -> อัปเดตโปรไฟล์
profileRouter.put('/:userId', upload.single('profileImage'), async (req, res) => {
    try {
        const { userId } = req.params;
        const { username } = req.body;
        const filename = req.file?.filename; // ถ้ามีรูป จะได้ชื่อไฟล์มา

        // โยนให้ Service จัดการต่อ
        const updatedUser = await profileService.updateProfile(String(userId), username, filename);

        res.status(200).json({ success: true, data: updatedUser });
    } catch (error) {
        res.status(500).json({ success: false, message: 'เซิร์ฟเวอร์ขัดข้อง' });
    }
});