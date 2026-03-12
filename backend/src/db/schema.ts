import { pgTable, serial, text, integer, uuid, boolean, timestamp } from 'drizzle-orm/pg-core';
import { relations } from 'drizzle-orm';

export const questions = pgTable('questions', {
  uuid: uuid('uuid').primaryKey().defaultRandom(),
  question: text('question').notNull(),
  category: text('category').notNull(),
  level: text('level').notNull(),
  explanation: text('explanation').notNull(), 
}); 

export const choices = pgTable('choices', {
  uuid: uuid('uuid').primaryKey().defaultRandom(),
  choices: text('choices').notNull(),
  isCorrect: boolean('is_correct').notNull(),
  questionId: uuid('question_id').references(() => questions.uuid, { onDelete: 'cascade' }).notNull(),
});

export const user = pgTable('user', {
  uuid: uuid('uuid').primaryKey().defaultRandom(),
  profileImage: text('profile_image').notNull(),
  username: text('username').notNull(),
  email: text('email').notNull(),
  password: text('password').notNull(),
  currentScore: integer('current_score').default(0),
});

export const shelter = pgTable('shelter', {
  uuid: uuid('uuid').primaryKey().defaultRandom(),
  name: text('name').notNull(),
  address: text('address').notNull(),
  phone: text('phone').notNull(),
  details: text('details').notNull(),
  owner: text('owner').notNull(),
});

export const donation = pgTable('donation', {
  userId: uuid('user_id')
    .references(() => user.uuid, { onDelete: 'cascade' })
    .notNull(),

  shelterId: uuid('shelter_id')
    .references(() => shelter.uuid, { onDelete: 'cascade' })
    .notNull(),
  
}); 

export const quiz_history = pgTable('quiz_history', {
  userId: uuid('user_id')
    .references(() => user.uuid, { onDelete: 'cascade' })
    .notNull(),
  questions_id: uuid('questions_id')
    .references(() => questions.uuid, { onDelete: 'cascade' })
    .notNull(),
  choices_id: uuid('choices_id')
    .references(() => choices.uuid, { onDelete: 'cascade' })
    .notNull(),
  is_correct: boolean('is_correct').notNull(),
}); 

export const score_history = pgTable('score_history', {
  uuid: uuid('uuid').primaryKey().defaultRandom(),

  userId: uuid('user_id')
    .references(() => user.uuid, { onDelete: 'cascade' })
    .notNull(),

  grammar: integer('grammar').default(0),
  vocab: integer('vocab').default(0),
  conversation: integer('conversation').default(0),
  sentence: integer('sentence').default(0),
  reading: integer('reading').default(0),

  createdAt: timestamp('created_at').defaultNow(),
});


//rules
//questions
export const questionsRelations = relations(questions, ({ many }) => ({
  choices: many(choices),
  quizHistory: many(quiz_history),
}));

//choices
export const choicesRelations = relations(choices, ({ one, many }) => ({
  question: one(questions, {
    fields: [choices.questionId],
    references: [questions.uuid],
  }),
  quizHistory: many(quiz_history),
}));

//user
export const userRelations = relations(user, ({ many }) => ({
  donations: many(donation),
  quizHistory: many(quiz_history),
  histories: many(score_history),
}));

//shelter
export const shelterRelations = relations(shelter, ({ many }) => ({
  donations: many(donation),
}));

//donation
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

//quiz_history
export const quiz_historyRelations = relations(quiz_history, ({ one }) => ({
  user: one(user, {
    fields: [quiz_history.userId],
    references: [user.uuid],
  }),
  question: one(questions, {
    fields: [quiz_history.questions_id],
    references: [questions.uuid],
  }),
  choice: one(choices, {
    fields: [quiz_history.choices_id],
    references: [choices.uuid],
  }),
}));

//score_history
export const score_historyRelations = relations(score_history, ({ one }) => ({
  user: one(user, {
    fields: [score_history.userId],
    references: [user.uuid],
  }),
}));
