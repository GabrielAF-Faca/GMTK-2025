class_name InputComponent
extends Node

var input_horizontal: float = 0.0
var input_vertical: float = 0.0

var direction: Vector2 = Vector2.ZERO
var roll: bool = false
var interact_just_pressed: bool = false
var interact_pressed: bool = false
var interact_just_released: bool = false
var activate_bullet_pressed: bool = false
var activate_bullet_released: bool = false

func _process(delta: float) -> void:
	
	direction = Vector2(
		Input.get_axis("move_left", "move_right"),
		Input.get_axis("move_up", "move_down")
	).normalized()
	
	roll = Input.is_action_just_released("roll")
	interact_just_pressed = Input.is_action_just_pressed("interact")
	interact_pressed = Input.is_action_pressed("interact")
	interact_just_released = Input.is_action_just_released("interact")
	activate_bullet_pressed = Input.is_action_just_pressed("activate_bullet")
	activate_bullet_released = Input.is_action_just_released("activate_bullet")
