import { Router } from 'express';
import { shelterService } from '../services/shelter.service.js';

export const shelterRouter = Router();

shelterRouter.get('/', async (req, res) => {
    try {
        const shelters = await shelterService.getAllShelters();
        res.status(200).json({ success: true, data: shelters });
    } catch (error) {
        console.error("Error fetching shelters:", error);
        res.status(500).json({ success: false, message: 'Failed to fetch shelters' });
    }
});
