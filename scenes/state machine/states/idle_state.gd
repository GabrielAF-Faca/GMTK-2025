class_name IdleState
extends State

@export var idle_time: float = 3.0 # Quanto tempo parado
@export var next_state_name: String = "" # Próximo estado

var timer: float = 0.0

func enter():
	print(host.name, " entrando no estado Idle.")
	host.get_node("AnimatedSprite2D").play("idle")
	#timer = idle_time

func exit():
	print(host.name, " saindo do estado Idle.")

func update(delta: float):
	timer -= delta
	if timer <= 0:
		# A transição é solicitada à máquina de estados.
		state_machine.change_state(next_state_name)
