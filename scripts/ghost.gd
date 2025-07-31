extends AnimatedSprite2D

var direction = Vector2(1,0)

func _ready():
	ghosting()
	
func set_property(tx_pos, tx_scale, d):
	position = tx_pos
	scale = tx_scale
	direction = d

func ghosting():
	flip_h = false if direction.x > 0 else true
	
	if direction.y != 0:
		play("down" if direction.y > 0 else "up")
	
	var tween_fade = get_tree().create_tween()
	
	tween_fade.tween_property(self, "self_modulate", Color(1.0, 1.0, 1.0, 0.0), 0.15)
	
	await tween_fade.finished
	
	queue_free()
