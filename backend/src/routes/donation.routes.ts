import { Router, Request, Response } from 'express';
import { donationService } from '../services/donation.service.js';

export const donationRouter = Router();

// POST /api/donation
donationRouter.post('/', async (req: Request, res: Response) => {
    try {
        const { userId, shelterId, amount } = req.body;

        if (!userId || !shelterId || !amount) {
            res.status(400).json({
                success: false,
                message: "ข้อมูลไม่ครบถ้วน (ต้องการ userId, shelterId, amount)"
            });
            return;
        }

        const result = await donationService.createDonation(userId, shelterId, amount);
        res.status(200).json({
            success: true,
            data: result
        });

    } catch (error: any) {
        console.error("Donation Route Error:", error);
        res.status(400).json({
            success: false,
            message: error.message || "เกิดข้อผิดพลาดในการบริจาค"
        });
    }
});

// GET /api/donation/total/:userId
donationRouter.get('/total/:userId', async (req: Request, res: Response) => {
    try {
        const { userId } = req.params;
        const total = await donationService.getDonatedScore(userId as string);
        res.status(200).json({
            success: true,
            data: { total }
        });
    } catch (error: any) {
        res.status(500).json({
            success: false,
            message: "ไม่สามารถดึงยอดบริจาครวมได้"
        });
    }
});
