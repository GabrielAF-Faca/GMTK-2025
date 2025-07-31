class_name StateMachine
extends Node

@export var initial_state: State

var current_state: State
var states: Dictionary = {}

func _ready():
	# Mapeia todos os nós de estado filhos em um dicionário pelo nome.
	for child in get_children():
		if child is State:
			states[child.name] = child
			# Informa a cada estado quem é seu gerente.
			child.state_machine = self
	# Inicia a máquina de estados.
	if initial_state:
		current_state = initial_state
		current_state.enter()

func _process(delta: float):
	if current_state:
		current_state.update(delta)

func _physics_process(delta: float):
	if current_state:
		current_state.physics_update(delta)

# A função principal em que é feita a troca dos estados.
func change_state(new_state_name: String):
	# Se o estado não existe ou é o atual, não faz nada.
	if not states.has(new_state_name) or states[new_state_name] == current_state:
		return
	# Chama a função de saída do estado atual.
	if current_state:
		current_state.exit()
	# Muda para o novo estado e chama sua função de entrada.
	current_state = states[new_state_name]
	current_state.enter()
