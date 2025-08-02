extends AnimationComponent

func handle_move_animation(move_direction: Vector2) -> void:
	handle_horizontal_flip(move_direction.x)
	if move_direction != Vector2.ZERO:
		last_dir = move_direction
		
	if move_direction.x != 0:
		sprite.play("walk")
		
	else:
		if last_dir.x != 0:
			sprite.play("idle")
