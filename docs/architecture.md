# GameParadise: Architecture

The GameParadise project is designed with a modular and scalable architecture to support the addition of new mini-games over time. This document outlines the key components and their interactions.

## Core Components

- **Lobby (`Lobby.tscn`)**: The main entry point of the application. It provides a user interface for players to select and launch different mini-games. This scene is responsible for transitioning to the selected game scene.

- **Game Scenes**: Each mini-game is encapsulated within its own dedicated scene. This approach promotes modularity and separation of concerns, making it easier to develop, debug, and maintain individual games.

- **Singletons**: Global state and services are managed through Godot's singleton pattern. These singletons are auto-loaded at startup and are accessible from any script in the project.

  - **`GlobalState.gd`**: A singleton that stores the application's global state, such as the player's score. This allows for persistent data across different scenes.

  - **`EventBus.gd`**: A global event bus that facilitates communication between different components of the application. It allows for a decoupled architecture where objects can signal events and other objects can listen and react to them without having direct references to each other.

## Game Structure

Each mini-game is organized into its own directory within the `games/` folder. This directory contains all the assets, scenes, and scripts related to that specific game. This modular structure makes it easy to add, remove, or modify games without affecting the rest of the project.

For example, the "Space Shooter" game is located in the `games/space_shooter/` directory, which contains:

- `scenes/`: Game scenes such as the main game scene, player, enemy, and laser scenes.
- `scripts/`: GDScript files for the game's logic.
- `assets/`: Image and audio assets for the game.

## Communication Flow

The `EventBus` singleton plays a crucial role in the communication between different parts of the application. For example, when an enemy is destroyed in the "Space Shooter" game, the enemy script emits a signal through the `EventBus`. The main game script listens for this signal and updates the score in the `GlobalState` singleton. This decoupled approach allows for a more flexible and maintainable codebase.

## Architectural Decisions

The architecture was designed to be modular and scalable. The following design decisions were made to achieve this:

### Global State Management

A global state management system was implemented using a **Singleton** (`GlobalState.gd`). This provides a single source of truth for the game's state (like score), decouples game components, and allows for easy state persistence.

### Event-Driven Architecture

An event bus singleton (`EventBus.gd`) was implemented to create a decoupled, event-driven architecture. Components can emit signals (events) on the event bus, and other components can listen for these events without direct coupling. This enhances modularity and scalability.

### Modular Game Structure

The project is organized into a modular structure. Each game is self-contained in its own directory within the `games/` folder, including its scenes, scripts, and assets. This makes it easy to add, remove, or update individual games without impacting the rest of the project.

## Conclusion

By implementing a global state management system, an event-driven architecture, and a modular project structure, GameParadise is well-positioned for future growth and the addition of new and exciting mini-games.
