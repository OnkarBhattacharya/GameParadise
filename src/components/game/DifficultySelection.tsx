'use client';
import { Button } from '@/components/ui/button';
import { Card, CardContent, CardHeader, CardTitle } from '@/components/ui/card';
import { type Team } from '@/lib/teams';
import type { Difficulty } from './KiddieKickersGame';
import { ShieldCheck, ShieldHalf, Shield } from 'lucide-react';

type DifficultySelectionProps = {
  playerTeam: Team;
  opponentTeam: Team;
  onDifficultySelect: (difficulty: Difficulty) => void;
};

const difficultyLevels: {
  level: Difficulty;
  label: string;
  icon: React.ElementType;
}[] = [
  { level: 'easy', label: 'Easy', icon: Shield },
  { level: 'medium', label: 'Medium', icon: ShieldHalf },
  { level: 'hard', label: 'Hard', icon: ShieldCheck },
];

export default function DifficultySelection({
  playerTeam,
  opponentTeam,
  onDifficultySelect,
}: DifficultySelectionProps) {
  return (
    <div className="w-full flex flex-col items-center text-center">
      <h2 className="text-3xl font-bold mb-6 text-foreground">Get Ready for a Match!</h2>
      <Card className="w-full max-w-md bg-card/80 shadow-xl mb-8">
        <CardHeader>
          <CardTitle className="text-2xl text-primary">Today's Matchup</CardTitle>
        </CardHeader>
        <CardContent className="flex items-center justify-around">
          <div className="flex flex-col items-center gap-2">
            <playerTeam.logo className="w-24 h-24" />
            <p className="font-bold text-lg">{playerTeam.name}</p>
          </div>
          <p className="text-4xl font-bold text-muted-foreground">VS</p>
          <div className="flex flex-col items-center gap-2">
            <opponentTeam.logo className="w-24 h-24" />
            <p className="font-bold text-lg">{opponentTeam.name}</p>
          </div>
        </CardContent>
      </Card>

      <h3 className="text-2xl font-bold mb-4 text-foreground">Select Difficulty</h3>
      <div className="flex flex-col sm:flex-row gap-4">
        {difficultyLevels.map(({ level, label, icon: Icon }) => (
          <Button
            key={level}
            onClick={() => onDifficultySelect(level)}
            size="lg"
            className="w-full sm:w-48 text-lg font-bold bg-primary hover:bg-primary/90 text-primary-foreground"
            variant="default"
          >
            <Icon className="w-6 h-6 mr-2" />
            {label}
          </Button>
        ))}
      </div>
    </div>
  );
}
