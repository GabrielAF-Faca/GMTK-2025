# animation_component_two_sides.gd
extends AnimationComponent

var can_spawn = true

func _process(delta: float) -> void:
	if is_instance_of(owner.attack_component.current_attack, SimpleMeleeAttack):
		
		if not is_instance_of(owner, Golem):
			return
		
		if sprite.frame == 6 and sprite.animation == "attack":
			owner.audio_component.play_audio_stream("batendo_chao")
			shake()
			
			if can_spawn:
				can_spawn = false
				var ataque = preload("res://scenes/ground_attack.tscn").instantiate()
				ataque.set_properties(get_tree().get_first_node_in_group("player").global_position)
				add_child(ataque)
		else:
			can_spawn = true

func handle_death_animation():
	sprite.play("die")
	
# A lógica de como a animação de movimento funciona está aqui.
func handle_move_animation(body: CharacterBody2D, move_direction: Vector2) -> void:
	# Garante que a animação de movimento possa repetir.
	sprite.sprite_frames.set_animation_loop("walk", true)
	sprite.sprite_frames.set_animation_loop("idle", true)
	
	handle_horizontal_flip(move_direction.x)
	if move_direction != Vector2.ZERO:
		last_dir = move_direction
		
	if move_direction.x != 0:
		sprite.play("walk")
		
	else:
		# Usa a função 'face_target' da classe base (AnimationComponent)
		face_target(body, body.player)
		if last_dir.x != 0:
			# Apenas toca 'idle' se não estiver no meio de um ataque.
			if not body.attack_component.attacking:
				sprite.play("idle")

# A lógica de como a animação de ataque funciona está aqui.
func handle_attack_animation(animation_name: String, loop: bool) -> void:
	
	sprite.sprite_frames.set_animation_loop(animation_name, loop)

	if sprite.is_playing() and sprite.animation == animation_name:
		return
	
	sprite.play(animation_name)

func shake():
	
	owner.player.camera_component.screen_shake(5, 0.8)
