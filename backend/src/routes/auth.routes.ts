import { Router, Request, Response } from 'express';
import { authService } from '../services/auth.service.js';

const router = Router();

// API: สมัครสมาชิก
router.post('/signup', async (req: Request, res: Response): Promise<void> => {
  try {
    const { username, email, password } = req.body;

    // เช็คว่าส่งข้อมูลมาครบไหม
    if (!username || !email || !password) {
      res.status(400).json({ message: 'Username, email, and password are required' });
      return;
    }

    const newUser = await authService.signUp({ username, email, password });
    res.status(201).json({ message: 'User created successfully', data: newUser });
  } catch (error: any) {
    res.status(400).json({ message: error.message });
  }
});

// API: เข้าสู่ระบบ
router.post('/login', async (req: Request, res: Response): Promise<void> => {
  try {
    const { email, password } = req.body;

    if (!email || !password) {
      res.status(400).json({ message: 'Email and password are required' });
      return;
    }

    const result = await authService.login({ email, password });
    res.status(200).json({ message: 'Login successful', data: result });
  } catch (error: any) {
    // รหัสผิดหรืออีเมลผิด จะเข้า catch นี้
    res.status(401).json({ message: error.message });
  }
});

// API: เข้าสู่ระบบด้วย Google
router.post('/google', async (req: Request, res: Response): Promise<void> => {
  try {
    const { email, username, profileImage } = req.body;

    if (!email) {
      res.status(400).json({ message: 'Email is required' });
      return;
    }

    const result = await authService.googleLogin({ email, username, profileImage });
    res.status(200).json({ message: 'Login successful', data: result });
  } catch (error: any) {
    res.status(401).json({ message: error.message });
  }
});

export default router;