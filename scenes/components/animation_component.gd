class_name AnimationComponent
extends Node

@export_subgroup("Nodes")
@export var sprite: Sprite2D
@export var animation_player: AnimationPlayer

func handle_horizontal_flip(move_direction:float) -> void:
	if move_direction == 0:
		return
	
	sprite.flip_h = false if move_direction > 0 else true

func handle_move_animation(move_direction: Vector2) -> void:
	handle_horizontal_flip(move_direction.x)
	
	if move_direction != Vector2.ZERO:
		sprite.play("run")
	else:
		sprite.play("idle")

func handle_roll_animation(move_direction: Vector2, dodge_duration: float) -> void:
	if move_direction != Vector2.ZERO:
		animation_player.speed_scale = 1.0/dodge_duration
		animation_player.play("roll_left" if move_direction.x < 0 else "roll_right")
