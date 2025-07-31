class_name AnimationComponent
extends Node

@export_subgroup("Nodes")
@export var sprite: AnimatedSprite2D
@export var animation_player: AnimationPlayer

@export_subgroup("Ghost")
@export var ghost_node: PackedScene

var last_dir = Vector2(1, 0)

func handle_horizontal_flip(move_direction:float) -> void:
	if move_direction == 0:
		return
	
	sprite.flip_h = false if move_direction > 0 else true

func handle_move_animation(move_direction: Vector2) -> void:
	handle_horizontal_flip(move_direction.x)
	if move_direction != Vector2.ZERO:
		last_dir = move_direction
		
		if move_direction.y != 0:
			sprite.play("run_down" if move_direction.y > 0 else "run_up")
		else:
			if move_direction.x != 0:
				sprite.play("run_side")
	
	else:
		if last_dir.y != 0:
			sprite.play("idle_down" if last_dir.y > 0 else "idle_up")
		else:
			if last_dir.x != 0:
				sprite.play("idle_side")
				

func handle_roll_animation(move_direction: Vector2, dodge_duration: float) -> void:
	if move_direction != Vector2.ZERO:
		animation_player.speed_scale = 1.0/dodge_duration
		animation_player.play("roll_left" if move_direction.x < 0 else "roll_right")
		

func add_ghost(body: CharacterBody2D, direction: Vector2) -> void:
	var ghost = ghost_node.instantiate()
	ghost.set_property(body.position, sprite.scale, direction, sprite.rotation)
	get_tree().current_scene.add_child(ghost)
