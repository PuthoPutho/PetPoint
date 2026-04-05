// ไฟล์: src/services/profile.service.ts
import { ProfileRepository } from '../repositories/profile.repository.js';

// เรียกใช้งาน Repository (เชฟ)
const profileRepo = new ProfileRepository();

export class ProfileService {
    // 1. ดึงโปรไฟล์
    async getProfile(userId: string) {
        return await profileRepo.findById(userId);
    }

    // 2. อัปเดตโปรไฟล์ (Logic เรื่อง Path รูปภาพย้ายมาอยู่นี่)
    async updateProfile(userId: string, username: string, filename?: string) {
        // เตรียมข้อมูลที่จะอัปเดต
        let updateData: any = {};
        
        if (username) {
            updateData.username = username;
        }

        // ถ้ามีไฟล์รูปภาพแนบมาด้วย ให้ต่อ Path เหมือนเดิมเป๊ะ
        if (filename) {
            updateData.profileImage = `/uploads/${filename}`;
        }

        // ส่งข้อมูลที่จัดทรงเสร็จแล้วไปให้ Database
        return await profileRepo.updateProfile(userId, updateData);
    }
}