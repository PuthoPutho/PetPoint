import { db } from '../db/index.js';
import { shelter as shelterTable } from '../db/schema.js';

export const shelterService = {
    getAllShelters: async () => {
        return await db.select().from(shelterTable);
    }
};
