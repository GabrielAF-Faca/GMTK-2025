class_name Golem
extends Boss

func _ready() -> void:
	super._ready()
	
	$AnimatedSprite2D.material.set_shader_parameter('hit_flash_on', false)
