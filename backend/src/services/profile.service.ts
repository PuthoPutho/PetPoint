import { ProfileRepository } from '../repositories/profile.repository.js';
import { donationService } from './donation.service.js';

// เรียกใช้งาน Repository (เชฟ)
const profileRepo = new ProfileRepository();

export class ProfileService {
    // 1. ดึงโปรไฟล์ (เพิ่มการคำนวณยอดบริจาครวมจากตาราง donation เข้าไปด้วย)
    async getProfile(userId: string) {
        const profile = await profileRepo.findById(userId);
        if (!profile) return null;

        const donatedTotal = await donationService.getDonatedScore(userId);
        
        return {
            ...profile,
            donatedScore: donatedTotal
        };
    }

    // 2. อัปเดตโปรไฟล์ ( แก้ให้รับลิงก์เต็มๆ จาก Supabase)
    // เปลี่ยนชื่อตัวแปรจาก filename เป็น imageUrl เพื่อให้ไม่งงครับ
    async updateProfile(userId: string, username: string, imageUrl?: string) {
        // เตรียมข้อมูลที่จะอัปเดต
        let updateData: any = {};
        
        if (username) {
            updateData.username = username;
        }

        // 🌟 ถ้ามีลิงก์รูปภาพ (Supabase URL) ส่งมา ให้เซฟลิงก์นั้นลง Database เลย ไม่ต้องเติม /uploads/ แล้ว
        if (imageUrl) {
            updateData.profileImage = imageUrl; 
        }

        // ส่งข้อมูลที่จัดทรงเสร็จแล้วไปให้ Database
        return await profileRepo.updateProfile(userId, updateData);
    }
}