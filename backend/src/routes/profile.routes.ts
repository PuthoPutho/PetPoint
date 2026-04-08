// ไฟล์: src/routes/profile.routes.ts
import { Router } from 'express';
import multer from 'multer';
import path from 'path';
import { createClient } from '@supabase/supabase-js';
import { ProfileService } from '../services/profile.service.js';

export const profileRouter = Router();

// เรียกใช้งาน Service (ผู้จัดการ)
const profileService = new ProfileService();

// ==========================================
// 1. ตั้งค่า Supabase & Multer (ถือไฟล์ไว้ใน RAM)
// ==========================================

// เชื่อมต่อกับ Supabase Storage
const supabaseUrl = process.env.SUPABASE_URL || '';
const supabaseKey = process.env.SUPABASE_KEY || '';
const supabase = createClient(supabaseUrl, supabaseKey);

// 🌟 เปลี่ยนเป็น memoryStorage ไม่ต้องสร้างโฟลเดอร์ uploads/ แล้ว
const storage = multer.memoryStorage();
const upload = multer({ storage: storage });

// ==========================================
// 2. API Routes
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
        console.error("Get Profile Error:", error);
        res.status(500).json({ success: false, message: 'เซิร์ฟเวอร์ขัดข้อง' });
    }
});

// PUT /:userId -> อัปเดตโปรไฟล์
profileRouter.put('/:userId', upload.single('profileImage'), async (req, res) => {
    try {
        const { userId } = req.params;
        const { username } = req.body;
        let finalImageUrl: string | undefined = undefined;

        // ถ้ามีการส่งรูปภาพมาด้วย ให้โยนขึ้น Supabase ทันที
        if (req.file) {
            const fileExt = path.extname(req.file.originalname);
            const fileName = `user_${userId}_${Date.now()}${fileExt}`; // สร้างชื่อไฟล์ใหม่

            // 1. อัปโหลดขึ้น Bucket ชื่อ 'uploads'
            const { data, error } = await supabase.storage
                .from('uploads')
                .upload(fileName, req.file.buffer, {
                    contentType: req.file.mimetype,
                });

            if (error) {
                console.error("Supabase Upload Error:", error);
                res.status(500).json({ success: false, message: 'อัปโหลดรูปลง Supabase ไม่สำเร็จ' });
                return;
            }

            // 2. ขอลิงก์ URL สาธารณะจาก Supabase
            const { data: publicUrlData } = supabase.storage
                .from('uploads')
                .getPublicUrl(fileName);

            // จะได้ลิงก์เช่น https://...supabase.co/storage/v1/object/public/profiles/user_xx.jpg
            finalImageUrl = publicUrlData.publicUrl;
        }

        //  โยนให้ Service จัดการต่อ (ส่งลิงก์ URL ของ Supabase ไปแทนชื่อไฟล์เดิม)
        const updatedUser = await profileService.updateProfile(String(userId), username, finalImageUrl);

        res.status(200).json({ success: true, message: 'อัปเดตโปรไฟล์สำเร็จ', data: updatedUser });
    } catch (error) {
        console.error("Update Profile Error:", error);
        res.status(500).json({ success: false, message: 'อัปเดตโปรไฟล์ไม่สำเร็จ' });
    }
});