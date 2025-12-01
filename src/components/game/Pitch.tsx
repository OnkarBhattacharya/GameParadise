'use client';
import { motion, AnimatePresence } from 'framer-motion';
import type { ShotOutcome } from './KiddieKickersGame';

const Goal = () => (
  <svg
    className="absolute inset-0 w-full h-full"
    viewBox="0 0 400 300"
    preserveAspectRatio="none"
  >
    {/* Goal frame */}
    <path
      d="M100 80 H300 V220 H280 V100 H120 V220 H100 Z"
      fill="white"
      stroke="#ccc"
      strokeWidth="2"
    />
    {/* Net pattern */}
    {Array.from({ length: 9 }).map((_, i) => (
      <line
        key={`h-${i}`}
        x1="105"
        y1={80 + i * 15.5}
        x2="295"
        y2={80 + i * 15.5}
        stroke="#FFFFFF80"
        strokeWidth="1"
      />
    ))}
    {Array.from({ length: 13 }).map((_, i) => (
      <line
        key={`v-${i}`}
        x1={100 + i * 15.3}
        y1="80"
        x2={100 + i * 15.3}
        y2="220"
        stroke="#FFFFFF80"
        strokeWidth="1"
      />
    ))}
  </svg>
);

const Goalkeeper = ({ diveDirection }: { diveDirection: number }) => {
  const diveVariants = {
    center: { x: 0, y: 0, rotate: 0, scale: 1 },
    left: { x: -60, y: -10, rotate: -45, scale: 1.1 },
    right: { x: 60, y: -10, rotate: 45, scale: 1.1 },
  };

  const currentDive = diveDirection === -1 ? 'left' : diveDirection === 1 ? 'right' : 'center';

  return (
    <motion.div
      className="absolute bottom-[27%] left-1/2 -translate-x-1/2"
      initial="center"
      animate={currentDive}
      variants={diveVariants}
      transition={{ type: 'spring', stiffness: 400, damping: 20 }}
    >
      <div className="relative w-16 h-24">
        {/* Body */}
        <div className="absolute top-4 left-1/2 -translate-x-1/2 w-8 h-12 bg-primary rounded-t-md" />
        {/* Head */}
        <div className="absolute top-0 left-1/2 -translate-x-1/2 w-6 h-6 bg-yellow-300 rounded-full" />
        {/* Arms */}
        <div className="absolute top-4 left-0 w-2 h-8 bg-primary rounded-l-md" />
        <div className="absolute top-4 right-0 w-2 h-8 bg-primary rounded-r-md" />
         {/* Legs */}
        <div className="absolute bottom-0 left-3 w-2 h-4 bg-primary" />
        <div className="absolute bottom-0 right-3 w-2 h-4 bg-primary" />
      </div>
    </motion.div>
  );
};


const OpponentBall = ({ shotDirection, isGoal }: { shotDirection: number, isGoal: boolean }) => {
    const ballVariants = {
      idle: { y: 0, scale: 0.5, x: 0 },
      kick: {
        y: isGoal? -180 : -150,
        scale: isGoal? 0.3 : 0.5,
        x: shotDirection * 80,
        transition: { duration: 0.5, ease: 'easeOut' },
      },
    };
  
    return (
      <motion.div
        className="absolute bottom-[5%] left-1/2 -translate-x-1/2"
        variants={ballVariants}
        initial="idle"
        animate={'kick'}
      >
        <div className="w-8 h-8 bg-white rounded-full shadow-lg flex items-center justify-center">
           <div className="w-4 h-4 bg-black rounded-full" />
        </div>
      </motion.div>
    );
  };

const Ball = ({ isKicking, isGoal }: { isKicking: boolean; isGoal: boolean }) => {
  const ballVariants = {
    idle: { y: 0, scale: 1, x: 0 },
    kick: {
      y: isGoal ? -180 : -150,
      scale: isGoal ? 0.3 : 0.5,
      x: Math.random() * 160 - 80,
      transition: { duration: 0.5, ease: 'easeOut' },
    },
  };

  return (
    <motion.div
      className="absolute bottom-[5%] left-1/2 -translate-x-1/2"
      variants={ballVariants}
      initial="idle"
      animate={isKicking ? 'kick' : 'idle'}
    >
      <div className="w-8 h-8 bg-white rounded-full shadow-lg flex items-center justify-center">
         <div className="w-4 h-4 bg-black rounded-full" />
      </div>
    </motion.div>
  );
};

type PitchProps = {
    isKicking: boolean;
    shotResult: { outcome: ShotOutcome; diveDirection: number } | null;
    isGoalkeeperTurn: boolean;
    opponentShotResult: { outcome: ShotOutcome; shotDirection: number } | null;
    playerDive: number | null;
}

export default function Pitch({ 
    isKicking, 
    shotResult, 
    isGoalkeeperTurn,
    opponentShotResult,
    playerDive
}: PitchProps) {
  return (
    <div className="w-full h-full relative overflow-hidden">
         <div
        className="absolute inset-0 bg-cover bg-center opacity-20"
        style={{
          backgroundImage: `url('https://images.unsplash.com/photo-1508098682722-e95fb63a4e16?q=80&w=2070&auto=format&fit=crop&ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D')`,
        }}
      />
      {/* Grass with lines */}
      <div className="absolute inset-0 bg-green-500/50">
        <div className="absolute bottom-0 w-full h-1/2 bg-green-600/50" />
        <div className="absolute top-1/2 left-1/2 -translate-x-1/2 -translate-y-1/2 w-1/2 h-1/4 border-2 border-white/50 rounded-b-full" />
        <div className="absolute bottom-[8%] left-1/2 -translate-x-1/2 w-3 h-3 bg-white rounded-full" />
      </div>
      <Goal />
      <AnimatePresence>
        {isGoalkeeperTurn && playerDive !== null && <Goalkeeper diveDirection={playerDive} />}
        {!isGoalkeeperTurn && shotResult && <Goalkeeper diveDirection={shotResult.diveDirection} />}
        {!shotResult && !isGoalkeeperTurn && <Goalkeeper diveDirection={0} />}
      </AnimatePresence>
      
      {isGoalkeeperTurn 
        ? opponentShotResult && <OpponentBall shotDirection={opponentShotResult.shotDirection} isGoal={opponentShotResult.outcome === 'goal'} />
        : <Ball isKicking={isKicking} isGoal={shotResult?.outcome === 'goal'} />
      }
    </div>
  );
}
