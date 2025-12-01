import type { SVGProps } from 'react';

export const Logo = (props: SVGProps<SVGSVGElement>) => (
  <svg
    xmlns="http://www.w3.org/2000/svg"
    viewBox="0 0 24 24"
    fill="none"
    stroke="currentColor"
    strokeWidth="2"
    strokeLinecap="round"
    strokeLinejoin="round"
    {...props}
  >
    <path d="M12 2L2 7l10 5 10-5-10-5z" fill="hsl(var(--primary))" />
    <path d="M2 17l10 5 10-5" fill="none" />
    <path d="M2 12l10 5 10-5" fill="none" />
    <path d="M12 22V12" stroke="hsl(var(--primary-foreground))" strokeWidth="1" />
    <circle cx="12" cy="12" r="3" fill="hsl(var(--accent))" stroke="hsl(var(--primary-foreground))" strokeWidth="1"/>
  </svg>
);

export const FootballIcon = (props: SVGProps<SVGSVGElement>) => (
  <svg
    xmlns="http://www.w3.org/2000/svg"
    viewBox="0 0 24 24"
    fill="none"
    stroke="currentColor"
    strokeWidth="2"
    strokeLinecap="round"
    strokeLinejoin="round"
    {...props}
  >
    <circle cx="12" cy="12" r="10" />
    <path d="M12 2a10 10 0 00-4.47 1.22m-2.9 2.9A10 10 0 003.85 12m.52 4.47a10 10 0 002.9 2.9M12 22a10 10 0 004.47-1.22m2.9-2.9A10 10 0 0020.15 12m-.52-4.47a10 10 0 00-2.9-2.9" />
    <path d="M12 7.5l-2.5 4.5h5L12 7.5z" fill="currentColor"/>
    <path d="M16.5 13.5l-2.5 4.5h5l-2.5-4.5z" fill="currentColor"/>
    <path d="M7.5 13.5l-2.5 4.5h5l-2.5-4.5z" fill="currentColor"/>
  </svg>
);
