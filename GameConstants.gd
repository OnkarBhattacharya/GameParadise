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

# Collision Sizes
const PLAYER_COLLISION_SIZE: Vector2 = Vector2(40, 40)
const PLAYER_COLLISION_LAYER: int = 0
const PLAYER_COLLISION_MASK: int = 2
const LASER_COLLISION_SIZE: Vector2 = Vector2(4, 16)
const ENEMY_COLLISION_SIZE: Vector2 = Vector2(32, 32)
const HEAVY_ENEMY_SCALE: Vector2 = Vector2(1.3, 1.3)
const BUBBLE_CLICK_RADIUS: float = 32.0
const BUBBLE_SPRITE_SIZE: Vector2 = Vector2(64, 64)