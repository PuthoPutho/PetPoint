import { pgTable, serial, text, integer, uuid, boolean } from 'drizzle-orm/pg-core';
import { relations } from 'drizzle-orm';

export const questions = pgTable('questions', {
  uuid: uuid('uuid').primaryKey().defaultRandom(),
  question: text('question').notNull(),
  category: text('category').notNull(),
  level: text('level').notNull(),
});

export const choices = pgTable('choices', {
  uuid: uuid('uuid').primaryKey().defaultRandom(),
  answer: text('answer').notNull(),
  isCorrect: boolean('is_correct').notNull(),
  questionId: uuid('question_id').references(() => questions.uuid, { onDelete: 'cascade' }).notNull(),
});

export const user = pgTable('user', {
  uuid: uuid('uuid').primaryKey().defaultRandom(),
  name: text('name').notNull(),
  email: text('email').notNull(),
  password: text('password').notNull(),
  score: integer('score').default(0),
});

export const questionsRelations = relations(questions, ({ many }) => ({
  choices: many(choices),
}));

export const choicesRelations = relations(choices, ({ one }) => ({
  question: one(questions, {
    fields: [choices.questionId],
    references: [questions.uuid],
  }),
}));
