extends Node2D

@onready var animated_sprite_2d: AnimatedSprite2D = $AnimatedSprite2D

func _ready() -> void:
	#animated_sprite_2d.play("default")
	$AnimationPlayer.play("activate_hit")

func set_properties(pos: Vector2):
	global_position = pos


func _on_animation_player_animation_finished(anim_name: StringName) -> void:
	queue_free()
