# GameParadise: Architecture

This document outlines the current architecture of the GameParadise project and provides recommendations for a more scalable and maintainable structure.

## Current Architecture

The project currently follows a simple scene-based architecture, which is suitable for a small game like Space Shooter. Each game entity (Player, Enemy, Laser) is a separate scene with its own script. The main scene, `SpaceShooter.tscn`, composes these individual scenes to create the game.

**Components:**

-   **Scenes**: `Player.tscn`, `Enemy.tscn`, `Laser.tscn` are the building blocks of the game. They are composed in the main `SpaceShooter.tscn`.
-   **Scripts**: Each scene has an attached script (`.gd` file) that defines its behavior.
-   **Groups**: Groups are used for collision detection (`players`, `enemies`, `lasers`).

**Data Flow:**

The game's state is managed implicitly within each scene's script. For example, the player's position is stored in the `Player.gd` script. Communication between scenes is handled through signals (`EnemyTimer` timeout) and direct parent-child relationships (`get_parent().add_child(laser)`).

## Future-Proofing the Architecture

As GameParadise grows to include more mini-games, the current architecture will become difficult to manage. A more robust, modular architecture is needed. Here are some recommendations:

### 1. Global State Management

Instead of each scene managing its own state, a global state management system should be implemented. This can be achieved using a **Singleton** (autoload) in Godot.

**Benefits:**

-   **Centralized State**: A single source of truth for the game's state (e.g., score, lives, current game).
-   **Decoupling**: Game components can react to state changes without being directly coupled to each other.
-   **Persistence**: Easily save and load game state.

**Implementation:**

1.  Create a `GlobalState.gd` script.
2.  Add it to the autoload list in `Project -> Project Settings -> Autoload`.
3.  This script can hold variables for score, lives, and other global data.

### 2. Event-Driven Architecture

An event-driven architecture will further decouple the game's components. Instead of direct function calls between scenes, an event bus can be used to broadcast and listen for events.

**Benefits:**

-   **Modularity**: Components can be added or removed without affecting others.
-   **Scalability**: New game mechanics can be added by simply creating new event listeners.

**Implementation:**

1.  Create an `EventBus.gd` script (as a Singleton/autoload).
2.  This script will have `emit_signal` and `connect` functions for custom signals (events).
3.  For example, when an enemy is destroyed, it can emit an `enemy_destroyed` signal on the `EventBus`, and the `GlobalState` can listen for this signal to update the score.

### 3. Modular Game Structure

To accommodate multiple mini-games, the project should be organized into a more modular structure.

**Proposed Structure:**

```
/games
  /space_shooter
    /scenes
    /scripts
    /assets
  /another_game
    ...
/common
  /scripts (e.g., GlobalState, EventBus)
  /assets (e.g., UI elements)
```

This structure will keep each game's code and assets separate, making it easier to manage and develop individual games.

## Conclusion

The current architecture is sufficient for the single Space Shooter game. However, to realize the vision of GameParadise as a platform for multiple mini-games, it is crucial to adopt a more scalable architecture. By implementing a global state management system, an event-driven architecture, and a modular project structure, GameParadise will be well-positioned for future growth.
