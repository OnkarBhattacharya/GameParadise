
import { AnshRidersLogo, KiaanStrikersLogo, RonaldoPowersLogo, MessiSkillsLogo } from "@/components/game/TeamLogos";

export type Team = {
  id: string;
  name: string;
  logo: React.ComponentType<{ className?: string }>;
};

export const teams: Team[] = [
  {
    id: 'ansh-riders',
    name: 'Ansh Riders',
    logo: AnshRidersLogo,
  },
  {
    id: 'kiaan-strikers',
    name: 'Kiaan Strikers',
    logo: KiaanStrikersLogo,
  },
  {
    id: 'ronaldo-powers',
    name: 'Ronaldo Powers',
    logo: RonaldoPowersLogo,
  },
  {
    id: 'messi-skills',
    name: 'Messi Skills',
    logo: MessiSkillsLogo,
  },
];
