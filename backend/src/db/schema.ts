import { pgTable, text, integer, uuid, boolean, timestamp } from 'drizzle-orm/pg-core';
import { relations } from 'drizzle-orm';


export const user = pgTable('user', {
  uuid: uuid('uuid').primaryKey().defaultRandom(),
  profileImage: text('profile_image'),
  username: text('username').notNull(),
  email: text('email').notNull().unique(),
  password: text('password').notNull(),
  provider: text('provider').default('local'),
  currentScore: integer('current_score').default(0),
  equippedPet: text('equipped_pet').default('cat_orange'), // เก็บ Pet ที่กำลังใช้งาน
  createdAt: timestamp('created_at').defaultNow(),
  updatedAt: timestamp('updated_at').defaultNow(),
});

export const quiz = pgTable('quiz', {
  uuid: uuid('uuid').primaryKey().defaultRandom(),
  title: text('title').notNull(),
  description: text('description'),
  category: text('category').notNull(),
  level: text('level').notNull(),
  tag: integer('tag').notNull(),
  quizImage: text('image'), 
  duration: integer('duration'),
  points: integer('points'),
  createdAt: timestamp('created_at').defaultNow(),
});

export const questions = pgTable('questions', {
  uuid: uuid('uuid').primaryKey().defaultRandom(),
  quizId: uuid('quiz_id').references(() => quiz.uuid, { onDelete: 'cascade' }).notNull(),
  question: text('question').notNull(),
  explanation: text('explanation').notNull(), 
}); 

export const choices = pgTable('choices', {
  uuid: uuid('uuid').primaryKey().defaultRandom(),
  choices: text('choices').notNull(),
  isCorrect: boolean('is_correct').notNull(),
  questionId: uuid('question_id').references(() => questions.uuid, { onDelete: 'cascade' }).notNull(),
});

export const quiz_attempts = pgTable('quiz_attempts', {
  uuid: uuid('uuid').primaryKey().defaultRandom(),
  userId: uuid('user_id').references(() => user.uuid, { onDelete: 'cascade' }).notNull(),
  quizId: uuid('quiz_id').references(() => quiz.uuid, { onDelete: 'cascade' }).notNull(),
  score: integer('score').notNull(), 
  createdAt: timestamp('created_at').defaultNow(),
});

export const quiz_history = pgTable('quiz_history', {
  uuid: uuid('uuid').primaryKey().defaultRandom(),
  attemptId: uuid('attempt_id').references(() => quiz_attempts.uuid, { onDelete: 'cascade' }).notNull(),
  userId: uuid('user_id').references(() => user.uuid, { onDelete: 'cascade' }).notNull(),
  questionId: uuid('question_id').references(() => questions.uuid, { onDelete: 'cascade' }).notNull(),
  choiceId: uuid('choice_id').references(() => choices.uuid, { onDelete: 'cascade' }).notNull(),
  isCorrect: boolean('is_correct').notNull(),
  createdAt: timestamp('created_at').defaultNow(),
});

export const user_skill_stats = pgTable('user_skill_stats', {
  uuid: uuid('uuid').primaryKey().defaultRandom(),
  userId: uuid('user_id').references(() => user.uuid, { onDelete: 'cascade' }).notNull().unique(), // 1 คนมีแค่ 1 แถว
  grammar: integer('grammar').default(0),
  vocab: integer('vocab').default(0),
  conversation: integer('conversation').default(0),
  sentence: integer('sentence').default(0),
  reading: integer('reading').default(0),
  updatedAt: timestamp('updated_at').defaultNow(),
});

export const shelter = pgTable('shelter', {
  uuid: uuid('uuid').primaryKey().defaultRandom(),
  name: text('name').notNull(),
  shelterImage: text('image'),
  address: text('address').notNull(),
  phone: text('phone').notNull(),
  details: text('details').notNull(),
  owner: text('owner').notNull(),
  createdAt: timestamp('created_at').defaultNow(),
});

export const donation = pgTable('donation', {
  uuid: uuid('uuid').primaryKey().defaultRandom(),
  amount: integer('amount').notNull(),
  userId: uuid('user_id').references(() => user.uuid, { onDelete: 'cascade' }).notNull(),
  shelterId: uuid('shelter_id').references(() => shelter.uuid, { onDelete: 'cascade' }).notNull(),
  createdAt: timestamp('created_at').defaultNow(),
}); 

// RELATIONS

export const quizRelations = relations(quiz, ({ many }) => ({
  questions: many(questions),
  attempts: many(quiz_attempts),
}));

export const questionsRelations = relations(questions, ({ one, many }) => ({
  quiz: one(quiz, {
    fields: [questions.quizId],
    references: [quiz.uuid],
  }),
  choices: many(choices),
  quizHistory: many(quiz_history),
}));

export const choicesRelations = relations(choices, ({ one, many }) => ({
  question: one(questions, {
    fields: [choices.questionId],
    references: [questions.uuid],
  }),
  quizHistory: many(quiz_history),
}));

export const userRelations = relations(user, ({ one, many }) => ({
  donations: many(donation),
  attempts: many(quiz_attempts),
  quizHistory: many(quiz_history),
  skillStats: one(user_skill_stats), 
}));

export const shelterRelations = relations(shelter, ({ many }) => ({
  donations: many(donation),
}));

export const donationRelations = relations(donation, ({ one }) => ({
  user: one(user, {
    fields: [donation.userId],
    references: [user.uuid],
  }),
  shelter: one(shelter, {
    fields: [donation.shelterId],
    references: [shelter.uuid],
  }),
}));

export const quizAttemptsRelations = relations(quiz_attempts, ({ one, many }) => ({
  user: one(user, {
    fields: [quiz_attempts.userId],
    references: [user.uuid],
  }),
  quiz: one(quiz, {
    fields: [quiz_attempts.quizId],
    references: [quiz.uuid],
  }),
  answers: many(quiz_history),
}));

export const quizHistoryRelations = relations(quiz_history, ({ one }) => ({
  attempt: one(quiz_attempts, {
    fields: [quiz_history.attemptId],
    references: [quiz_attempts.uuid],
  }),
  user: one(user, {
    fields: [quiz_history.userId],
    references: [user.uuid],
  }),
  question: one(questions, {
    fields: [quiz_history.questionId],
    references: [questions.uuid],
  }),
  choice: one(choices, {
    fields: [quiz_history.choiceId],
    references: [choices.uuid],
  }),
}));

export const userSkillStatsRelations = relations(user_skill_stats, ({ one }) => ({
  user: one(user, {
    fields: [user_skill_stats.userId],
    references: [user.uuid],
  }),
}));