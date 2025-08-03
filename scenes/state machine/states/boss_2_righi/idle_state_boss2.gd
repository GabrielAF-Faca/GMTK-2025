# idle_state_boss2.gd
class_name IdleStateBoss2
extends State

var timer: float = 0.0

func _ready() -> void:
	state_name = "idle"

func enter():
	# Ao entrar no estado, o boss para de se mover
	host.move_direction = Vector2.ZERO
	# Define um tempo aleatório para ficar parado, dentro dos limites definidos no Inspector
	timer = rng.randf_range(state_time_min, state_time_max)

func update(delta: float):
	# Decrementa o timer a cada frame
	timer -= delta
	# Quando o tempo acabar, transita para o estado de Patrulha
	if timer <= 0:
		state_machine.change_state("patrol")
