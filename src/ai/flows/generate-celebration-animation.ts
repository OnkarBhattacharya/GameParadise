'use server';
/**
 * @fileOverview Flow to generate celebration animations when a goal is scored.
 *
 * - generateCelebrationAnimation - A function that generates a celebration animation.
 * - GenerateCelebrationAnimationInput - The input type for the generateCelebrationAnimation function.
 * - GenerateCelebrationAnimationOutput - The return type for the generateCelebrationAnimation function.
 */

import {ai} from '@/ai/genkit';
import {z} from 'genkit';
import wav from 'wav';
import {googleAI} from '@genkit-ai/google-genai';

const GenerateCelebrationAnimationInputSchema = z.object({
  teamName: z.string().describe('The name of the team that scored.'),
  playerName: z.string().describe('The name of the player who scored.'),
});
export type GenerateCelebrationAnimationInput = z.infer<
  typeof GenerateCelebrationAnimationInputSchema
>;

const GenerateCelebrationAnimationOutputSchema = z.object({
  animationDataUri: z
    .string()
    .describe(
      'A data URI containing the animation data in a suitable format (e.g., GIF, video/mp4).'
    )
    .optional(),
  celebrationSpeech: z
    .string()
    .describe('Audio data as data URI in WAV format')
    .optional(),
});
export type GenerateCelebrationAnimationOutput = z.infer<
  typeof GenerateCelebrationAnimationOutputSchema
>;

export async function generateCelebrationAnimation(
  input: GenerateCelebrationAnimationInput
): Promise<GenerateCelebrationAnimationOutput> {
  return generateCelebrationAnimationFlow(input);
}

const generateCelebrationAnimationFlow = ai.defineFlow(
  {
    name: 'generateCelebrationAnimationFlow',
    inputSchema: GenerateCelebrationAnimationInputSchema,
    outputSchema: GenerateCelebrationAnimationOutputSchema,
  },
  async input => {
    const {teamName, playerName} = input;
    const celebrationText = `The crowd goes wild! ${playerName} of ${teamName} scored a goal!`;

    const [imageRes, audioRes] = await Promise.all([
      // Generate Image
      ai.generate({
        model: googleAI.model('imagen-4.0-fast-generate-001'),
        prompt: `A cartoon style celebration for a kids football game. ${teamName} just scored. Player ${playerName} is celebrating.`,
      }),
      // Generate Speech
      ai.generate({
        model: googleAI.model('gemini-2.5-flash-preview-tts'),
        config: {
          responseModalities: ['AUDIO'],
          speechConfig: {
            voiceConfig: {
              prebuiltVoiceConfig: {voiceName: 'Algenib'},
            },
          },
        },
        prompt: celebrationText,
      }),
    ]);

    const animationDataUri = imageRes.media.url;
    let celebrationSpeech: string | undefined = undefined;

    if (audioRes.media) {
      const audioBuffer = Buffer.from(
        audioRes.media.url.substring(audioRes.media.url.indexOf(',') + 1),
        'base64'
      );
      const wavData = await toWav(audioBuffer);
      celebrationSpeech = `data:audio/wav;base64,${wavData}`;
    }

    return {
      animationDataUri,
      celebrationSpeech,
    };
  }
);

async function toWav(
  pcmData: Buffer,
  channels = 1,
  rate = 24000,
  sampleWidth = 2
): Promise<string> {
  return new Promise((resolve, reject) => {
    const writer = new wav.Writer({
      channels,
      sampleRate: rate,
      bitDepth: sampleWidth * 8,
    });

    let bufs = [] as any[];
    writer.on('error', reject);
    writer.on('data', function (d) {
      bufs.push(d);
    });
    writer.on('end', function () {
      resolve(Buffer.concat(bufs).toString('base64'));
    });

    writer.write(pcmData);
    writer.end();
  });
}
