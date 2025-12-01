'use server';

import { generateAIOpponent } from '@/ai/flows/generate-ai-opponent';
import { generateCelebrationAnimation } from '@/ai/flows/generate-celebration-animation';
import type { Difficulty } from '@/components/game/KiddieKickersGame';

export async function getAIOpponentMove(difficulty: Difficulty, gameState: string) {
  try {
    const response = await generateAIOpponent({
      difficulty,
      teamComposition: 'Standard goalkeeper and penalty taker',
      currentGameState: gameState,
    });
    return response;
  } catch (error) {
    console.error('Error generating AI opponent move:', error);
    throw new Error('Failed to get AI opponent strategy.');
  }
}

export async function getCelebration(teamName: string, playerName: string) {
    try {
        const response = await generateCelebrationAnimation({
            teamName,
            playerName,
        });
        return response;
    } catch (error) {
        console.error('Error generating celebration:', error);
        throw new Error('Failed to generate celebration animation.');
    }
}
