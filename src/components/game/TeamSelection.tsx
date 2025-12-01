'use client';

import { teams, type Team } from '@/lib/teams';
import { Card, CardContent, CardHeader, CardTitle } from '@/components/ui/card';
import { motion } from 'framer-motion';

type TeamSelectionProps = {
  onTeamSelect: (team: Team) => void;
};

export default function TeamSelection({ onTeamSelect }: TeamSelectionProps) {
  return (
    <div className="w-full flex flex-col items-center">
      <h2 className="text-3xl font-bold mb-8 text-foreground">Choose Your Team!</h2>
      <div className="grid grid-cols-2 md:grid-cols-4 gap-4 md:gap-6">
        {teams.map((team, index) => (
          <motion.div
            key={team.id}
            initial={{ opacity: 0, y: 20 }}
            animate={{ opacity: 1, y: 0 }}
            transition={{ delay: index * 0.1 }}
            whileHover={{ scale: 1.05 }}
            whileTap={{ scale: 0.95 }}
          >
            <Card
              onClick={() => onTeamSelect(team)}
              className="cursor-pointer bg-card hover:bg-primary/10 transition-colors duration-200 shadow-lg overflow-hidden group"
            >
              <CardHeader className="p-0">
                <div className="aspect-square w-full flex items-center justify-center bg-muted/50 p-4">
                  <team.logo className="w-20 h-20 text-primary group-hover:scale-110 transition-transform duration-300" />
                </div>
              </CardHeader>
              <CardContent className="p-4">
                <CardTitle className="text-center text-lg md:text-xl font-headline text-foreground">{team.name}</CardTitle>
              </CardContent>
            </Card>
          </motion.div>
        ))}
      </div>
    </div>
  );
}
