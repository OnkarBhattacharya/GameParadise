extends RigidBody2D

func _on_input_event(viewport, event, shape_idx):
  if event is InputEventMouseButton and event.pressed and event.button_index == MOUSE_BUTTON_LEFT:
    GlobalState.score += 10
    EventBus.emit_signal("bubble_popped")
    queue_free()
