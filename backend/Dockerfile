FROM node:20-slim

WORKDIR /app

COPY package*.json ./

RUN npm install

RUN apt-get update && apt-get install -y netcat-traditional && rm -rf /var/lib/apt/lists/*

COPY . .

RUN npm run build

EXPOSE 3000

CMD ["sh", "-c", "npx tsx src/db/migrate.ts && npm start"]