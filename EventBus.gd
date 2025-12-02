extends Node

# Game state signals
signal game_over(final_score: int)
signal game_paused()
signal game_resumed()
signal game_state_changed(new_state: GameConstants.GameState)

# Score and progression signals
signal score_updated(new_score: int)
signal level_changed(level: int)
signal wave_started(wave: int)

# Space Shooter signals
signal enemy_destroyed(enemy_type: GameConstants.EnemyType)
signal player_died(remaining_lives: int)
signal laser_fired()
signal power_up_collected(type: GameConstants.PowerUpType)

# Bubble Burst signals
signal bubble_popped(points: int)
signal bubble_missed()

# UI signals
signal ui_update_requested()