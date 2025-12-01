extends Area2D

@export var speed = 400
@export var laser_scene: PackedScene

var screen_size

func _ready():
    screen_size = get_viewport_rect().size

func _process(delta):
    var velocity = Vector2.ZERO
    if Input.is_action_pressed("move_left"):
        velocity.x -= 1
    if Input.is_action_pressed("move_right"):
        velocity.x += 1

    position += velocity * speed * delta
    position.x = clamp(position.x, 0, screen_size.x)

    if Input.is_action_just_pressed("shoot"):
        shoot()

func shoot():
    var laser = laser_scene.instantiate()
    laser.position = position
    get_parent().add_child(laser)

func _on_body_entered(body):
    if body.is_in_group("enemies"):
        hide()
        body.queue_free()
        EventBus.player_died.emit()
