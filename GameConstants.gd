extends Node

# GameConstants is now an autoload singleton

enum EnemyType {
	BASIC,
	FAST,
	HEAVY
}

enum GameState {
	MENU,
	PLAYING,
	PAUSED,
	GAME_OVER
}

enum PowerUpType {
	RAPID_FIRE,
	SHIELD,
	MULTI_SHOT
}

# Space Shooter Constants
const PLAYER_SPEED: float = 400.0
const LASER_SPEED: float = 500.0
const ENEMY_MIN_SPEED: float = 80.0
const ENEMY_MAX_SPEED: float = 200.0
const FIRE_RATE: float = 0.3
const INITIAL_SPAWN_RATE: float = 0.8
const MIN_SPAWN_RATE: float = 0.2
const MAX_ENEMIES: int = 10
const INITIAL_LIVES: int = 3

# Bubble Burst Constants
const BUBBLE_DESPAWN_TIME: float = 8.0
const BUBBLE_POINTS: int = 10
const BUBBLE_SPAWN_RATE: float = 1.5
const BUBBLE_MIN_SPAWN_RATE: float = 0.5
const MAX_BUBBLES: int = 8

# UI Constants
const FONT_SIZE_LARGE: int = 24
const FONT_SIZE_MEDIUM: int = 20
const FONT_SIZE_SMALL: int = 16