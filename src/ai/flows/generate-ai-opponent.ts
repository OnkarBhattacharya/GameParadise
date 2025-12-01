'use server';

/**
 * @fileOverview Generates a simple AI opponent for the Kiddie Kickers game using GenAI.
 *
 * - generateAIOpponent - A function that creates an AI opponent strategy.
 * - GenerateAIOpponentInput - The input type for the generateAIOpponent function.
 * - GenerateAIOpponentOutput - The return type for the generateAIOpponent function.
 */

import {ai} from '@/ai/genkit';
import {z} from 'genkit';

const GenerateAIOpponentInputSchema = z.object({
  difficulty: z
    .enum(['easy', 'medium', 'hard'])
    .describe('The difficulty level of the AI opponent.'),
  teamComposition: z
    .string()
    .describe('The composition of the AI opponent team.'),
  currentGameState: z
    .string()
    .describe('The current state of the game, e.g., score, time left.'),
});
export type GenerateAIOpponentInput = z.infer<typeof GenerateAIOpponentInputSchema>;

const GenerateAIOpponentOutputSchema = z.object({
  strategy: z
    .string()
    .describe('The AI opponent strategy for the current game state.'),
});
export type GenerateAIOpponentOutput = z.infer<typeof GenerateAIOpponentOutputSchema>;

export async function generateAIOpponent(input: GenerateAIOpponentInput): Promise<GenerateAIOpponentOutput> {
  return generateAIOpponentFlow(input);
}

const prompt = ai.definePrompt({
  name: 'generateAIOpponentPrompt',
  input: {schema: GenerateAIOpponentInputSchema},
  output: {schema: GenerateAIOpponentOutputSchema},
  prompt: `You are an AI that generates strategies for a football game opponent, specifically for kids.

You will receive the difficulty, team composition, and current game state. Based on this information, you will formulate a simple strategy for the AI opponent.

Difficulty: {{{difficulty}}}
Team Composition: {{{teamComposition}}}
Current Game State: {{{currentGameState}}}

Formulate a strategy that aligns with the difficulty level. For example, an easy difficulty should have a more passive strategy, while a hard difficulty should be more aggressive.

Ensure the strategy is appropriate for kids, focusing on fair play and fun. Avoid complex or highly tactical maneuvers.

Output the strategy in a concise and easy-to-understand manner.

Strategy:`,
});

const generateAIOpponentFlow = ai.defineFlow(
  {
    name: 'generateAIOpponentFlow',
    inputSchema: GenerateAIOpponentInputSchema,
    outputSchema: GenerateAIOpponentOutputSchema,
  },
  async input => {
    const {output} = await prompt(input);
    return output!;
  }
);
