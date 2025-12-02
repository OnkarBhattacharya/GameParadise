extends Node2D

# EffectsManager is now an autoload singleton

## Creates explosion effect at position with optional color.
func create_explosion(pos: Vector2, color: Color = Color.WHITE) -> void:
	var particles := CPUParticles2D.new()
	particles.position = pos
	particles.emitting = true
	particles.amount = 20
	particles.lifetime = 1.0
	particles.emission_shape = CPUParticles2D.EMISSION_SHAPE_SPHERE
	particles.spread = 45.0
	particles.initial_velocity_min = 50.0
	particles.initial_velocity_max = 150.0
	particles.scale_amount_min = 0.5
	particles.scale_amount_max = 1.5
	particles.color = color
	
	add_child(particles)
	
	# Auto-remove after animation
	await get_tree().create_timer(particles.lifetime + 0.5).timeout
	if is_instance_valid(particles):
		particles.queue_free()

## Shakes camera for specified duration and strength.
func screen_shake(duration: float = 0.3, strength: float = 10.0) -> void:
	var camera := get_viewport().get_camera_2d()
	if not camera:
		return
	
	var original_pos := camera.global_position
	var tween := create_tween()
	
	for i in range(int(duration * 30)):  # 30 FPS shake
		var shake_offset := Vector2(
			randf_range(-strength, strength),
			randf_range(-strength, strength)
		)
		tween.tween_property(camera, "global_position", original_pos + shake_offset, 1.0/30.0)
	
	tween.tween_property(camera, "global_position", original_pos, 0.1)