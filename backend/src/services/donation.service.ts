import { db } from '../db/index.js';
import { donation as donationTable, user as userTable } from '../db/schema.js';
import { eq, sql } from 'drizzle-orm';

export const donationService = {
    // 1. สร้างรายการบริจาค
    createDonation: async (userId: string, shelterId: string, amount: number) => {
        return await db.transaction(async (tx) => {
            // เช็คคะแนนผู้ใช้ก่อน
            const [user] = await tx.select({ currentScore: userTable.currentScore })
                .from(userTable)
                .where(eq(userTable.uuid, userId));

            if (!user || (user.currentScore ?? 0) < amount) {
                throw new Error('คะแนนไม่เพียงพอสำหรับการบริจาค');
            }

            // 1. หักคะแนนผู้ใช้
            await tx.update(userTable)
                .set({
                    currentScore: sql`${userTable.currentScore} - ${amount}`
                })
                .where(eq(userTable.uuid, userId));

            // 2. บันทึกประวัติการบริจาค
            const [newDonation] = await tx.insert(donationTable)
                .values({
                    userId,
                    shelterId,
                    amount
                })
                .returning();

            // 3. ดึงคะแนนใหม่กลับไปให้ Frontend
            const [updatedUser] = await tx.select({ currentScore: userTable.currentScore })
                .from(userTable)
                .where(eq(userTable.uuid, userId));

            const donatedTotal = await donationService.getDonatedScore(userId);

            return {
                newScore: updatedUser.currentScore,
                donatedTotal: donatedTotal,
                donation: newDonation
            };
        });
    },

    // 2. คำนวณยอดบริจาครวมของ User
    getDonatedScore: async (userId: string) => {
        const result = await db.select({
            total: sql<number>`cast(sum(${donationTable.amount}) as int)`
        })
        .from(donationTable)
        .where(eq(donationTable.userId, userId));

        return result[0]?.total ?? 0;
    }
};
