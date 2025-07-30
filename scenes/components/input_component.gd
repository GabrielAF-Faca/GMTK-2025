class_name InputComponent
extends Node

var input_horizontal: float = 0.0
var input_vertical: float = 0.0

var direction: Vector2 = Vector2.ZERO

func _process(delta: float) -> void:
	input_horizontal = Input.get_axis("move_left", "move_right")
	input_vertical = Input.get_axis("move_up", "move_down")
	
	direction = Vector2(input_horizontal, input_vertical).normalized()
