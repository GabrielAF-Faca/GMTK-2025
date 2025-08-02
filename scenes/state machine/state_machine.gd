class_name StateMachine
extends Node

@export var initial_state: State
@export var states: Dictionary[String,State]

var current_state: State

func _ready():
	# Mapeia todos os nós de estado filhos em um dicionário pelo nome.
	for state in states:
		states[state].state_machine = self
		states[state].host = get_parent()
		
	# Aguarda o carregamento de toda a árvore da cena
	await get_tree().process_frame
	# Inicia a máquina de estados.
	if initial_state:
		current_state = initial_state
		current_state.enter()
	else: print("STATE MACHINE ERROR: Estado inicial não foi definido no Inspetor para ", owner.name)

func _process(delta: float):
	if current_state: current_state.update(delta)

#func _physics_process(delta: float):
	#if current_state: current_state.physics_update(delta)

# A função principal em que é feita a troca dos estados.
func change_state(state=""):
	# Se o estado não existe ou é o atual, não faz nada.
	var new_state_name = state
	
	if not state.length():
		new_state_name = choose_random_state()
	
	if not states.has(new_state_name) or states[new_state_name] == current_state:
		return
	# Chama a função de saída do estado atual.
	if current_state:
		current_state.exit()
	# Muda para o novo estado e chama sua função de entrada.
	current_state = states[new_state_name]
	current_state.enter()

func choose_random_state() -> String:
	
	if states.size():
		return states.keys().pick_random()
		
	return "idle"
