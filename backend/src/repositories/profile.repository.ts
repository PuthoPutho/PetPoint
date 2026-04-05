// ไฟล์: src/repositories/profile.repository.ts
import { eq } from 'drizzle-orm';
import { db } from '../db/index.js';
import { user } from '../db/schema.js';

export class ProfileRepository {
    // ฟังก์ชันดึงข้อมูลโปรไฟล์
    async findById(userId: string) {
        const [foundUser] = await db.select().from(user).where(eq(user.uuid, userId));
        return foundUser;
    }

    // ฟังก์ชันอัปเดตโปรไฟล์
    async updateProfile(userId: string, updateData: any) {
        const [updatedUser] = await db.update(user)
            .set(updateData)
            .where(eq(user.uuid, userId))
            .returning();
        return updatedUser;
    }
}