# PetPoint Backend

Express.js backend with TypeScript, Drizzle ORM, and PostgreSQL.

## 🚀 Getting Started

### Prerequisites
- Docker & Docker Compose

### Running the Project
1. Navigate to the `backend` folder.
2. Build and start the containers:
   ```bash
   docker compose up -d --build --force-recreate
   ```
3. The server will be running on [http://localhost:3000](http://localhost:3000).

---

## 🏗️ Database Migrations

This project automates migrations. Whenever the Docker container starts, it runs `npm run db:migrate` automatically.

### Automated Migration (Code-based)
The system uses the SQL files in `backend/drizzle/` to keep your database in sync. This is the safest way to handle schema changes.
```bash
npm run db:migrate
## OR can just run this command
npm run db:up
```

### Prototyping (Fast Sync)
If you just want to push experimental schema changes without creating SQL files:
```bash
npm run db:push
```

---

## 📂 Layered Architecture
- **Repository Layer** (`src/repositories/`): Direct database interactions.
- **Service Layer** (`src/services/`): Business logic and orchestration.
- **Routes Layer** (`src/routes/`): API endpoint definitions.
- **Database Layer** (`src/db/`): Schema and connection setup.

---

## 🛠️ Tech Stack
- **Framework**: Express.js
- **Language**: TypeScript (ES Modules)
- **ORM**: Drizzle ORM
- **Database**: PostgreSQL
- **Containerization**: Docker & Docker Compose

Verification Plan
Automated Tests
Run npm run db:seed and verify data in the database (via Drizzle Studio or logs).
Run npm run db:delete and verify the tables are empty.
Manual Verification
Provide docker exec commands for running scripts inside the container:
docker exec -it 8eea61376e5e0e042a821755dfb07b2394738a1a96bd80433651475ceef9015b npm run db:seed
docker exec -it 8eea61376e5e0e042a821755dfb07b2394738a1a96bd80433651475ceef9015b npm run db:delete