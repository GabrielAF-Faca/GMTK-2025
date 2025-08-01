class_name PatrolState
extends State

@export var path_node_path: NodePath

# A velocidade com que o chefe se move entre os pontos.
@export var patrol_speed: float = 80.0
# A distância mínima para considerar que um ponto foi "alcançado".
@export var arrival_threshold: float = 10.0

## --- Variáveis Internas ---
var waypoints: Array[Vector2] = []
var current_waypoint_index: int = 0

func enter():
	print(host.name, " entrando no estado Patrol.")
	# Pega o nó do caminho e carrega as posições dos pontos.
	var path_node = get_node_or_null(path_node_path)
	# Em caso de erro em encontrar o nó do caminho, transiciona para o estado Idle
	if not path_node:
		print("PATROL STATE ERROR: O nó do caminho não foi encontrado! Verifique o NodePath.")
		state_machine.change_state("Idle") 
		return
	# Limpa a lista antiga e preenche com as novas posições.
	waypoints.clear()
	for point in path_node.get_children():
		if point is Node2D:
			waypoints.append(point.global_position)
	# Se não houver pontos, não há para onde ir.
	if waypoints.is_empty():
		print("PATROL STATE ERROR: Nenhum ponto encontrado no nó do caminho.")
		state_machine.change_state("Idle")
		return
		
	current_waypoint_index = 0
	
	if host.has_node("AnimatedSprite2D"):
		host.get_node("AnimatedSprite2D").play("walk")
		
# Lógica de movimento que roda em um loop de física.
func physics_update(_delta: float):
	# Se não tivermos para onde ir, não faz nada.
	if waypoints.is_empty():
		return
	# 1. Pega a posição do alvo atual.
	var target_position = waypoints[current_waypoint_index]
	# 2. Verifica a distância até o alvo.
	var distance_to_target = host.global_position.distance_to(target_position)
	# 3. Se o chefe chegou perto o suficiente do ponto...
	if distance_to_target < arrival_threshold:
		# ...avança para o próximo ponto no ciclo.
		current_waypoint_index = (current_waypoint_index + 1) % waypoints.size()
		# NOTA: Aqui é onde a lógica do Autômato Rúnico entraria!
		# Você poderia emitir um sinal para o chefe "ativar" a runa.
		# Ex: host.emit_signal("rune_activated", current_waypoint_index)
		# Atualiza o alvo para o novo ponto.
		target_position = waypoints[current_waypoint_index]
	# 4. Move o chefe em direção ao alvo.
	var direction = host.global_position.direction_to(target_position)
	host.velocity = direction * patrol_speed
	host.move_and_slide()
