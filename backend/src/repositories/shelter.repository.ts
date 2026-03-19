import { randomUUID, UUID } from 'node:crypto';
import { db } from '../db/index.js';
import { shelter, donation } from '../db/schema.js';
import { eq } from 'drizzle-orm';

export class ShelterRepository {
    async getAllShelters() {
        return await db.query.shelter.findMany({
            with: {
                donations: true,
            },
        });
    }

    async getShelterById(id: UUID) {
        return await db.query.shelter.findFirst({
            where: eq(shelter.uuid, id),
            with: {
                donations: true,
            },
        });
    }

}
