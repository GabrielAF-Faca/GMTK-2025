class_name AnimationComponent
extends Node

@export_subgroup("Nodes")
@export var sprite: AnimatedSprite2D
@export var animation_player: AnimationPlayer

@export_subgroup("Player")
@export var shot_aura_animation: AnimatedSprite2D
@export var ghost_node: PackedScene

signal attack_finished

var last_dir = Vector2(1, 0)

func handle_horizontal_flip(move_direction:float) -> void:
	if move_direction == 0:
		return
	
	sprite.flip_h = false if move_direction > 0 else true

func face_target(body, target:CharacterBody2D) -> void:

	sprite.flip_h = false if target.global_position.x > body.global_position.x  else true

func handle_move_animation(body:CharacterBody2D, move_direction: Vector2) -> void:
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
	ghost.set_property(sprite.global_position, sprite, direction)
	get_tree().current_scene.add_child(ghost)

func handle_charge_shot_animation():
	# --- CORREÇÃO ---
	# Redefine a velocidade da animação para a velocidade normal (1.0)
	# --- CORRECTION ---
	# Reset the animation speed to normal (1.0)
	# before playing the charge shot animation.
	animation_player.speed_scale = 1.0
	animation_player.play("charge_shot")
	toggle_charge_animation_sprites(true)
	shot_aura_animation.play("aura")
	
	modulate_fx_appearance(shot_aura_animation)
	
func modulate_fx_appearance(fx: AnimatedSprite2D):
	fx.modulate = Color(1.0, 1.0, 1.0, 0.0)
	fx.scale = Vector2(0.0, 0.0)
	
	var tween = get_tree().create_tween()
	
	tween.tween_property(fx, "modulate", Color(1.0, 1.0, 1.0), 0.1)
	tween.tween_property(fx, "scale", Vector2(0.55, 0.699), 0.1)
	tween.play()
	

func toggle_charge_animation_sprites(visible: bool):
	shot_aura_animation.visible = visible
