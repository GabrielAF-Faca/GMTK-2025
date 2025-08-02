extends AnimatedSprite2D

func set_property(pos: Vector2):
	position = pos

func _ready() -> void:
	play("default")

func _process(delta: float) -> void:
	var tween = get_tree().create_tween()
	tween.tween_property(self, "scale", Vector2(1.2,1.2), 0.4)
	tween.tween_property(self, "modulate", Color(1.0, 1.0, 1.0, 0.0), 0.6)
	tween.set_ease(Tween.EASE_OUT)
	tween.set_trans(Tween.TRANS_CUBIC)
	tween.tween_callback(queue_free)
	tween.play()
	
