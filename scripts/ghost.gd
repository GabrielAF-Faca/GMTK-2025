extends AnimatedSprite2D

var direction = Vector2(1,0)

func _ready():
	ghosting()
	
func set_property(tx_pos, sprite, d):
	position = tx_pos
	scale = sprite.scale
	rotation = sprite.rotation
	sprite_frames = sprite.sprite_frames
	animation = sprite.animation
	frame = sprite.frame
	speed_scale = 0.0

func ghosting():
	
	var tween_fade = get_tree().create_tween()
	
	tween_fade.tween_property(self, "self_modulate", Color(1.0, 1.0, 1.0, 0.0), 0.15)
	
	await tween_fade.finished
	
	queue_free()
