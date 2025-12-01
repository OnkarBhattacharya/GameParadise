<<<<<<< HEAD
# GameParadise

Welcome to GameParadise, a collection of fun and engaging mini-games developed with the Godot Engine. This project serves as a central hub for various games, starting with "Space Shooter" and "Bubble Burst."

## Games

### Space Shooter

A classic arcade-style game where you control a spaceship, shoot down enemies, and avoid collisions.

**Controls:**

- **Move Left**: Left Arrow Key
- **Move Right**: Right Arrow Key
- **Shoot**: Spacebar

### Bubble Burst

A simple and fun game where you pop bubbles to score points. Click on the bubbles before they disappear off the screen!

**Controls:**

- **Pop Bubble**: Left Mouse Click

## Getting Started

### Prerequisites

- [Godot Engine](https://godotengine.org/download) (Version 4.x recommended)

### Running the Game

1.  Clone this repository.
2.  Open the Godot Engine project manager.
3.  Click "Import" and navigate to the cloned repository's root folder.
4.  Select the `project.godot` file.
5.  Click "Run" (play icon) in the top-right corner of the Godot editor.

## Project Structure

- `Lobby.tscn`: The main entry point of the application, allowing players to choose a game.
- `games/`
  - `space_shooter/`: Contains all the assets, scenes, and scripts for the Space Shooter game.
  - `bubble_burst/`: Contains all the assets, scenes, and scripts for the Bubble Burst game.
- `singletons/`: Contains the global state and event bus for the application.
- `docs/`: Contains project documentation like the blueprint and architecture.
=======
# Kiddie Kickers Championship

This is a web-based penalty shootout game where you can test your skills against an AI opponent. Choose your favorite team, select a difficulty level, and see if you can outsmart the goalkeeper to score goals. But be careful, you'll also have to defend your own goal!

## Features

*   **Team Selection:** Choose from a variety of teams to represent.
*   **AI Opponent:** The AI opponent's difficulty can be set to easy, medium, or hard.
*   **Goal Celebration:** See a fun celebration animation when you score a goal.
*   **Game Over Screen:** A summary of the match is displayed at the end of the game.
*   **Responsive Design:** The game is designed to be played on both desktop and mobile devices.

## How to Play

1.  **Select a Team:** Choose the team you want to play as.
2.  **Select Difficulty:** Choose the difficulty of the AI opponent.
3.  **Take Your Shot:** Click on the goal to aim your shot.
4.  **Defend Your Goal:** Click on the goal to dive and try to save the opponent's shot.
5.  **Win the Game:** The player with the most goals after 5 shots wins the game.

## Getting Started

To run the game locally, follow these steps:

1.  Clone the repository.
2.  Install the dependencies:
    ```bash
    npm install
    ```
3.  Run the development server:
    ```bash
    npm run dev
    ```
4.  Open your browser and navigate to `http://localhost:9002`.

## Architecture

This project is built with [Next.js](https://nextjs.org/), a React framework for building server-rendered and statically generated web applications.

### Frontend

The frontend is built with [React](https://react.dev/) and [TypeScript](https://www.typescriptlang.org/). The UI components are built using [shadcn/ui](https://ui.shadcn.com/), which is a collection of re-usable components built with [Tailwind CSS](https://tailwindcss.com/) and [Radix UI](https://www.radix-ui.com/).

The game's state is managed using React's built-in state management features, including the `useState`, `useEffect`, and `useCallback` hooks. The game follows a state machine pattern, with the current game state being tracked in the `KiddieKickersGame` component.

### Backend

The backend logic for the AI opponent is handled by a [Next.js Server Action](https://nextjs.org/docs/app/building-your-application/rendering/server-components#server-actions). The `getAIOpponentMove` function is called from the client to get the AI's move, which is determined by a prompt sent to an AI model.

## Contributing

Contributions are welcome! If you have any ideas, suggestions, or bug reports, please open an issue or submit a pull request.

## License

This project is licensed under the MIT License. See the [LICENSE](LICENSE) file for more details.
>>>>>>> 5e2976606e3cc9c3a6fc57dac36e9d84931a1acd
