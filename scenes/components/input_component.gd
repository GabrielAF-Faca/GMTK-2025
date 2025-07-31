class_name InputComponent
extends Node

var input_horizontal: float = 0.0
var input_vertical: float = 0.0

var direction: Vector2 = Vector2.ZERO
var roll: bool = false

func _process(delta: float) -> void:
	
	direction = Vector2(
		Input.get_axis("move_left", "move_right"),
		Input.get_axis("move_up", "move_down")
	).normalized()
	
	roll = Input.is_action_just_released("roll")
