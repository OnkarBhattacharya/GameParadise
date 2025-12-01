'use client';

import { Card, CardContent } from '@/components/ui/card';
import type { Team } from '@/lib/teams';
import type { Shot, ShotOutcome } from './KiddieKickersGame';
import { X, CheckCircle2 } from 'lucide-react';
import { cn } from '@/lib/utils';

type ScoreboardProps = {
  playerTeam: Team;
  opponentTeam: Team;
  scores: { playerScore: number; opponentScore: number };
  shots: Shot[];
};

const ShotIndicator = ({ outcome }: { outcome: ShotOutcome }) => {
    const baseClasses = "w-5 h-5 md:w-6 md:h-6 rounded-full flex items-center justify-center border-2";

    if (outcome === 'goal') {
        return (
            <div className={cn(baseClasses, "bg-green-500 border-green-300")}>
                <CheckCircle2 className="w-4 h-4 text-white" />
            </div>
        );
    }
    if (outcome === 'miss') {
        return (
            <div className={cn(baseClasses, "bg-red-500 border-red-300")}>
                <X className="w-4 h-4 text-white" />
            </div>
        );
    }
    return <div className={cn(baseClasses, "bg-muted-foreground/20 border-muted-foreground/50")} />;
};

export default function Scoreboard({ playerTeam, opponentTeam, scores, shots }: ScoreboardProps) {
  return (
    <Card className="w-full max-w-lg bg-card/70 backdrop-blur-sm shadow-lg">
      <CardContent className="p-3 md:p-4">
        <div className="flex items-center justify-between">
          {/* Player Team */}
          <div className="flex items-center gap-2 md:gap-4 flex-1 justify-start">
            <playerTeam.logo className="w-8 h-8 md:w-12 md:h-12" />
            <span className="hidden sm:inline font-bold text-base md:text-lg truncate">{playerTeam.name}</span>
          </div>

          {/* Score */}
          <div className="flex flex-col items-center px-2">
            <div className="flex items-baseline gap-2 md:gap-4">
                <span className="text-3xl md:text-5xl font-bold text-primary">{scores.playerScore}</span>
                <span className="text-xl md:text-2xl font-semibold text-muted-foreground">-</span>
                <span className="text-3xl md:text-5xl font-bold text-primary">{scores.opponentScore}</span>
            </div>
            <div className="flex gap-1.5 md:gap-2 mt-2">
                {shots.map((shot, index) => (
                    <ShotIndicator key={`player-shot-${index}`} outcome={shot.player} />
                ))}
            </div>
            {/* Opponent shots could be displayed here if logic is extended
            <div className="flex gap-2 mt-2">
                {shots.map((shot, index) => (
                    <ShotIndicator key={`opponent-shot-${index}`} outcome={shot.opponent} />
                ))}
            </div>
            */}
          </div>

          {/* Opponent Team */}
          <div className="flex items-center gap-2 md:gap-4 flex-1 justify-end">
             <span className="hidden sm:inline font-bold text-base md:text-lg text-right truncate">{opponentTeam.name}</span>
            <opponentTeam.logo className="w-8 h-8 md:w-12 md:h-12" />
          </div>
        </div>
      </CardContent>
    </Card>
  );
}
