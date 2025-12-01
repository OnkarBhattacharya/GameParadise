# GameParadise

Welcome to GameParadise, a versatile multi-game hub built with the Godot Engine. This project serves as a centralized platform for a collection of fun, arcade-style mini-games, all accessible from a single lobby.

## 🎮 Games Included

GameParadise currently features three exciting games:

1.  **Space Shooter:** A classic top-down arcade shooter. Pilot your spaceship, dodge enemy fire, and destroy waves of alien invaders to achieve a high score.
2.  **Bubble Burst:** A fast-paced and colorful bubble-popping game. Pop as many bubbles as you can before time runs out to set a new record.
3.  **Ronaldo vs Messi:** A thrilling penalty shootout game. Take control of a legendary player, aim your shot, and try to score past a reactive goalkeeper.

## 🚀 Getting Started

To get the project running on your local machine, follow these simple steps:

1.  **Clone the Repository**
    Open your terminal and run the following git command:
    ```bash
    git clone <YOUR_REPOSITORY_URL>
    ```

2.  **Open in Godot Engine**
    - Launch the Godot Engine (version 4.x is recommended).
    - In the Project Manager, click the **Import** button.
    - Navigate to the cloned repository folder and select the `project.godot` file.

3.  **Run the Project**
    - Once the project is imported, select it from the list and click **Run** (or press F5) to start the game lobby.

## 📂 Project Structure

The project is organized to be modular and easy to navigate, with a clear separation between core systems and individual games.
├── games/
│   ├── bubble_burst/       # Bubble Burst game assets and scenes
│   ├── ronaldo_vs_messi/   # Ronaldo vs Messi game assets and scenes
│   └── space_shooter/      # Space Shooter game assets and scenes
├── EffectsManager.gd       # Manages visual effects like explosions
├── EventBus.gd             # Global event bus for signal-based communication
├── GameConstants.gd        # Centralized constants (speeds, rates, etc.)
├── GlobalState.gd          # Manages global state (score, lives, pause)
├── Lobby.tscn              # Main game selection lobby scene
├── project.godot           # The main Godot project file
└── README.md               # Project documentation


### Core Systems (Autoloaded Singletons)

These scripts are loaded globally and provide foundational services across the entire project:

-   **`GlobalState.gd`**: Manages shared game state, including `score`, `high_score`, `lives`, `level`, and pause status (`is_paused`). It also handles saving and loading the high score.
-   **`EventBus.gd`**: A central event bus that allows different game components to communicate without being directly coupled. It defines signals for key events like `score_updated`, `game_paused`, and `player_died`.
-   **`GameConstants.gd`**: A static container for game-wide constants, such as player speed, fire rates, and UI font sizes. This makes tweaking game balance easy and centralized.
-   **`EffectsManager.gd`**: A utility for instantiating and managing temporary visual effects, like explosions, ensuring they are properly added to the scene and cleaned up afterward.

## 🤝 How to Contribute

Contributions are welcome! If you'd like to add a new game, fix a bug, or improve an existing feature, please follow these steps:

1.  Fork the repository.
2.  Create a new branch for your feature (`git checkout -b feature/add-new-game`).
3.  Commit your changes (`git commit -m 'Add: New awesome game'`).
4.  Push to the branch (`git push origin feature/add-new-game`).
5.  Open a Pull Request.

When adding a new game, please create a new folder under the `games/` directory and ensure it is self-contained.