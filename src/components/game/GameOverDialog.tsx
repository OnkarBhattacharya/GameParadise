'use client';

import { Button } from '@/components/ui/button';
import { AlertDialog, AlertDialogContent, AlertDialogHeader, AlertDialogTitle, AlertDialogDescription, AlertDialogFooter, AlertDialogAction } from '@/components/ui/alert-dialog';
import { Trophy, ShieldX, Grip } from 'lucide-react';
import Image from 'next/image';

type GameOverDialogProps = {
  scores: { playerScore: number; opponentScore: number };
  onRestart: () => void;
};

export default function GameOverDialog({ scores, onRestart }: GameOverDialogProps) {
  const { playerScore, opponentScore } = scores;
  let result: 'win' | 'lose' | 'draw';
  let title: string;
  let Icon: React.ElementType;
  let colorClass: string;
  let imageUrl: string;

  if (playerScore > opponentScore) {
    result = 'win';
    title = 'You Won!';
    Icon = Trophy;
    colorClass = 'text-yellow-400';
    imageUrl = 'https://images.unsplash.com/photo-1521464307223-355013f44342?q=80&w=2070&auto=format&fit=crop&ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D';
  } else if (playerScore < opponentScore) {
    result = 'lose';
    title = 'You Lost!';
    Icon = ShieldX;
    colorClass = 'text-red-500';
    imageUrl = 'https://images.unsplash.com/photo-1605328216447-16d7f57c23a4?q=80&w=2070&auto=format&fit=crop&ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D';
  } else {
    result = 'draw';
    title = "It's a Draw!";
    Icon = Grip;
    colorClass = 'text-muted-foreground';
    imageUrl = 'https://images.unsplash.com/photo-1582298532328-3d145446f5a3?q=80&w=2070&auto=format&fit=crop&ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D';
  }

  return (
    <AlertDialog open={true}>
      <AlertDialogContent className="p-0 max-w-lg">
        <div className="relative h-64 w-full">
            <Image src={imageUrl} layout="fill" objectFit="cover" alt={title} className="rounded-t-lg" />
            <div className="absolute inset-0 bg-black/50 flex flex-col items-center justify-center p-6">
                 <Icon className={`w-24 h-24 ${colorClass} drop-shadow-lg`} />
                 <AlertDialogTitle className="text-5xl font-bold text-white drop-shadow-lg mt-4">{title}</AlertDialogTitle>
            </div>
        </div>
        <AlertDialogHeader className="px-6 pt-6 pb-2 items-center">
          <AlertDialogDescription className="text-xl font-semibold text-center">
            Final Score: {playerScore} - {opponentScore}
          </AlertDialogDescription>
        </AlertDialogHeader>
        <AlertDialogFooter className="px-6 pb-6 pt-2">
          <AlertDialogAction onClick={onRestart} className="w-full text-lg bg-primary hover:bg-primary/90 text-primary-foreground">
            Play Again
          </AlertDialogAction>
        </AlertDialogFooter>
      </AlertDialogContent>
    </AlertDialog>
  );
}
