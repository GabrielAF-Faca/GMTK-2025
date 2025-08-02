class_name IdleState
extends State

var timer: float = 0.0

func _ready() -> void:
	state_name = "idle"

func enter():
	enter_message()
	#host.get_node("AnimatedSprite2D").play("idle")
	timer = rng.randf_range(state_time_min, state_time_max)

func exit():
	exit_message()

func update(delta: float):
	timer -= delta
	if timer <= 0:
		# A transição é solicitada à máquina de estados.
		state_machine.change_state()
