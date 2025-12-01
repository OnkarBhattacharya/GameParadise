'use client';

import { useState } from 'react';
import { Button } from '@/components/ui/button';
import { Slider } from '@/components/ui/slider';
import { FootballIcon } from '../icons';

type ControlsProps = {
  onShoot: (aim: number) => void;
  disabled: boolean;
};

export default function Controls({ onShoot, disabled }: ControlsProps) {
  const [aim, setAim] = useState([0]);

  const handleShoot = () => {
    onShoot(aim[0]);
  };

  return (
    <div className="w-full max-w-md flex flex-col items-center gap-4 p-4 bg-background/80 rounded-lg shadow-md">
      <div className="w-full">
        <label htmlFor="aim-slider" className="text-sm font-bold text-muted-foreground mb-2 block">
          AIM
        </label>
        <Slider
          id="aim-slider"
          min={-1}
          max={1}
          step={0.1}
          value={aim}
          onValueChange={setAim}
          disabled={disabled}
          className="w-full"
        />
        <div className="flex justify-between text-xs text-muted-foreground mt-1">
            <span>Left</span>
            <span>Center</span>
            <span>Right</span>
        </div>
      </div>
      <Button
        onClick={handleShoot}
        disabled={disabled}
        size="lg"
        className="w-full text-2xl font-extrabold !h-16 bg-accent hover:bg-accent/90 text-accent-foreground shadow-lg transform active:scale-95 transition-transform"
      >
        <FootballIcon className="w-8 h-8 mr-3 animate-spin" style={{ animationDuration: disabled ? '2s' : '10s' }} />
        {disabled ? 'Wait...' : 'SHOOT!'}
      </Button>
    </div>
  );
}
