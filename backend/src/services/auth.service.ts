import bcrypt from 'bcryptjs'; 
import jwt from 'jsonwebtoken';
import { authRepository } from '../repositories/auth.repository.js';

// ควรกำหนด JWT_SECRET ในไฟล์ .env ของคุณ (เช่น JWT_SECRET=mysecretkey)
const JWT_SECRET = process.env.JWT_SECRET || 'default-secret-key'; 

export const authService = {
  // ฟังก์ชันสมัครสมาชิก
  async signUp(data: any) {
    // 1. เช็คว่ามี Email นี้ในระบบหรือยัง
    const existingUser = await authRepository.findUserByEmail(data.email);
    if (existingUser) {
      throw new Error('Email already exists');
    }

    // 2. เข้ารหัสผ่าน (Hash)
    const salt = await bcrypt.genSalt(10);
    const hashedPassword = await bcrypt.hash(data.password, salt);

    // 3. บันทึกลง Database
    const newUser = await authRepository.createUser({
      username: data.username,
      email: data.email,
      password: hashedPassword,
      provider: 'local',
    });

    // 4. ลบรหัสผ่านออกจากตัวแปร ก่อนส่งกลับไปที่หน้าบ้านเพื่อความปลอดภัย
    const { password, ...userWithoutPassword } = newUser;
    return userWithoutPassword;
  },

  // ฟังก์ชันเข้าสู่ระบบ
  async login(data: any) {
    // 1. หา User จาก Email
    const existingUser = await authRepository.findUserByEmail(data.email);
    if (!existingUser || !existingUser.password) {
      throw new Error('Invalid email or password');
    }

    // 2. นำรหัสผ่านที่กรอกมา เทียบกับรหัสผ่านที่ Hash ไว้ใน Database
    const isValidPassword = await bcrypt.compare(data.password, existingUser.password);
    if (!isValidPassword) {
      throw new Error('Invalid email or password');
    }

    // 3. รหัสถูก ออก JWT Token ให้ (กำหนดให้หมดอายุใน 1 วัน)
    const token = jwt.sign(
      { uuid: existingUser.uuid, email: existingUser.email },
      JWT_SECRET,
      { expiresIn: '1d' }
    );

    const { password, ...userWithoutPassword } = existingUser;
    
    // ดึงยอดบริจาครวมของ user
    const { donationService } = await import('./donation.service.js');
    const donatedTotal = await donationService.getDonatedScore(existingUser.uuid);
    
    // ส่งข้อมูล User พร้อมกับ Token กลับไป
    return { 
      user: {
        ...userWithoutPassword,
        donatedScore: donatedTotal
      }, 
      token 
    };
  }
};