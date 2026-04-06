import { eq } from 'drizzle-orm';
import { db } from '../db/index.js';
import { user } from '../db/schema.js';

export const authRepository = {
  // หา User จาก Email
  async findUserByEmail(email: string) {
    const [foundUser] = await db.select().from(user).where(eq(user.email, email));
    return foundUser;
  },

  // สร้าง User ใหม่
  async createUser(data: typeof user.$inferInsert) {
    const [newUser] = await db.insert(user).values(data).returning();
    return newUser;
  }
};