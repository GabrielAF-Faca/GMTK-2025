class_name AnimationComponent
extends Node

@export_subgroup("Nodes")
@export var sprite: AnimatedSprite2D

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
