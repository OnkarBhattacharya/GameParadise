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

- `project.godot`: The main Godot project file.
- `Lobby.tscn`: The main entry point of the application, allowing players to choose a game.
- `EventBus.gd`: A global event bus for communication between different parts of the application (autoloaded singleton).
- `GlobalState.gd`: A global state manager for storing data like score (autoloaded singleton).
- `games/`
  - `space_shooter/`: Contains all the assets, scenes, and scripts for the Space Shooter game.
  - `bubble_burst/`: Contains all the assets, scenes, and scripts for the Bubble Burst game.
- `docs/`: Contains project documentation like the blueprint and architecture.
