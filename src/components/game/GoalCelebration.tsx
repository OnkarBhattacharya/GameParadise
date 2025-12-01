'use client';
import { useEffect, useState, useRef } from 'react';
import { getCelebration } from '@/app/actions';
import { Button } from '@/components/ui/button';
import { Dialog, DialogContent, DialogHeader, DialogTitle, DialogFooter } from '@/components/ui/dialog';
import { Loader2 } from 'lucide-react';
import Image from 'next/image';
import Confetti from 'react-confetti';

type GoalCelebrationProps = {
  teamName: string;
  playerName: string;
  onFinish: () => void;
};

export default function GoalCelebration({
  teamName,
  playerName,
  onFinish,
}: GoalCelebrationProps) {
  const [animationUri, setAnimationUri] = useState<string | null>(null);
  const [speechUri, setSpeechUri] = useState<string | null>(null);
  const [isLoading, setIsLoading] = useState(true);
  const [showConfetti, setShowConfetti] = useState(false);
  const audioRef = useRef<HTMLAudioElement>(null);

  useEffect(() => {
    const fetchCelebration = async () => {
      setIsLoading(true);
      try {
        const result = await getCelebration(teamName, playerName);
        if (result.animationDataUri) {
            setAnimationUri(result.animationDataUri);
        }
        if (result.celebrationSpeech) {
            setSpeechUri(result.celebrationSpeech);
        }
      } catch (error) {
        console.error('Failed to fetch celebration:', error);
      } finally {
        setIsLoading(false);
        setShowConfetti(true);
      }
    };
    fetchCelebration();
  }, [teamName, playerName]);

  useEffect(() => {
    if (speechUri && audioRef.current) {
        audioRef.current.play().catch(e => console.error("Audio play failed:", e));
    }
  }, [speechUri]);


  return (
    <Dialog open={true}>
        {showConfetti && <Confetti recycle={false} onConfettiComplete={() => setShowConfetti(false)} />}
      <DialogContent className="sm:max-w-[425px] bg-background text-foreground" onPointerDownOutside={(e) => e.preventDefault()}>
        <DialogHeader>
          <DialogTitle className="text-center text-3xl font-bold text-accent">GOOOAL!</DialogTitle>
        </DialogHeader>
        <div className="flex items-center justify-center min-h-[250px] my-4 rounded-lg bg-muted">
          {isLoading ? (
            <div className="flex flex-col items-center gap-4">
              <Loader2 className="w-12 h-12 animate-spin text-primary" />
              <p className="text-muted-foreground">Generating celebration...</p>
            </div>
          ) : animationUri ? (
            <Image src={animationUri} alt="Goal celebration" width={400} height={250} className="rounded-md" unoptimized />
          ) : (
            <p>What a goal!</p>
          )}
        </div>
        <DialogFooter>
          <Button onClick={onFinish} className="w-full bg-primary hover:bg-primary/90 text-primary-foreground text-lg">
            Continue
          </Button>
        </DialogFooter>
        {speechUri && <audio ref={audioRef} src={speechUri} />}
      </DialogContent>
    </Dialog>
  );
}
