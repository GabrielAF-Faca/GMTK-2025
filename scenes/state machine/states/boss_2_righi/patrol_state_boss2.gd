# patrol_state_boss2.gd
class_name PatrolStateBoss2
extends State

# Distância para considerar um ponto como "alcançado"
@export var arrival_threshold: float = 10.0
# Distância em que o boss deteta o jogador para atacar
@export var attack_range: float = 30.0

var waypoints: Array[Vector2] = []
var current_waypoint_index: int = 0

func _ready() -> void:
	state_name = "patrol"

func enter():
	var patrol_points_node = host.standing_points
	if not patrol_points_node:
		print("PATROL STATE ERROR: Nó 'StandingPoints' não encontrado no boss.")
		state_machine.change_state("idle") # Volta para idle como segurança
		return
		
	# Pega os pontos de patrulha
	waypoints.clear()
	for point in patrol_points_node.get_children():
		waypoints.append(point.global_position)
		
	if waypoints.is_empty():
		print("PATROL STATE ERROR: Nenhum ponto de patrulha encontrado.")
		state_machine.change_state("idle")
		return
	
	# Em vez de um ponto aleatório, vai para o próximo na sequência
	current_waypoint_index = (current_waypoint_index + 1) % waypoints.size()

func update(_delta: float):
	# --- Lógica de Transição ---
	# Verifica a distância até o jogador
	var distance_to_player = host.global_position.distance_to(host.player.global_position)
	
	# Se o jogador estiver dentro do alcance, muda para o estado de ataque
	if distance_to_player < attack_range:
		state_machine.change_state("attack")
		return # Para a execução para evitar que ele se mova mais

	# --- Lógica de Movimento ---
	var target_position = waypoints[current_waypoint_index]

	# Se chegou ao ponto de patrulha, muda para o estado Idle para uma pausa
	if host.global_position.distance_to(target_position) < arrival_threshold:
		host.move_direction = Vector2.ZERO
		state_machine.change_state("idle")
	else:
		# Se não, continua a mover-se em direção ao ponto
		var direction = host.global_position.direction_to(target_position)
		host.move_direction = direction
