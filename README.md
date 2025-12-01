# GameParadise: Space Shooter

This is the first mini-game, "Space Shooter," for the GameParadise platform. It's a simple, classic arcade-style game built with the Godot Engine.

## About The Project

GameParadise is envisioned as a hub for various fun, child-friendly mini-games. This Space Shooter game serves as the foundational project.

**Core Features:**
- Player movement (Left/Right)
- Shooting projectiles (Spacebar)
- Spawning enemies
- Collision detection (Player-Enemy, Laser-Enemy)

## Getting Started

### Prerequisites

- [Godot Engine](https://godotengine.org/download) (Version 4.x recommended)

### Running the Game

1.  Clone this repository.
2.  Open the Godot Engine project manager.
3.  Click "Import" and navigate to the cloned repository's root folder.
4.  Select the `project.godot` file.
5.  Click "Run" (play icon) in the top-right corner of the Godot editor.

## Controls

- **Move Left**: Left Arrow Key
- **Move Right**: Right Arrow Key
- **Shoot**: Spacebar

## Project Structure

- `Player/`: Contains the Player scene (`Player.tscn`) and its script (`Player.gd`).
- `Enemy/`: Contains the Enemy scene (`Enemy.tscn`) and its script (`Enemy.gd`).
- `Laser/`: Contains the Laser scene (`Laser.tscn`) and its script (`Laser.gd`).
- `SpaceShooter.tscn`: The main game scene that orchestrates the game.
- `SpaceShooter.gd`: The main script that manages enemy spawning.
- `docs/`: Contains project documentation like the blueprint and architecture.
