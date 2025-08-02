class_name PatrolState
extends State


# A distância mínima para considerar que um ponto foi "alcançado".
@export var arrival_threshold: float = 10.0

## --- Variáveis Internas ---
var waypoints: Array[Vector2] = []
var current_waypoint_index: int = 0

func _ready() -> void:
	state_name = "patrol"

func enter():
	var patrol_points_node = host.standing_points
	print(host.name, " entrando no estado Patrol.")
	# Limpa a lista antiga e preenche com as novas posições.
	waypoints.clear()
	for point in patrol_points_node.get_children():
		waypoints.append(point.global_position)
	# Se não houver pontos, não há para onde ir.
	if waypoints.is_empty():
		print("PATROL STATE ERROR: Nenhum ponto encontrado no nó do caminho.")
		state_machine.change_state()
		return
		
	while true:
		var point = waypoints.find(waypoints.pick_random())
		
		if point != current_waypoint_index:
			current_waypoint_index = point
			break

func update(_delta: float):
	var target_position = waypoints[current_waypoint_index]

	if host.global_position.distance_to(target_position) < arrival_threshold+rng.randf_range(-arrival_threshold, arrival_threshold):
		host.move_direction = Vector2.ZERO
		state_machine.change_state()
	else:
		var direction = host.global_position.direction_to(target_position)
		host.move_direction = direction

func exit():
	print(host.name, " saindo do estado Patrol.")
	
	
	#if host.has_node("AnimatedSprite2D"):
		#host.get_node("AnimatedSprite2D").play("walk")
		
# Lógica de movimento que roda em um loop de física.
#func physics_update(_delta: float):
	## Se não tivermos para onde ir, não faz nada.
	#if waypoints.is_empty():
		#return
	## 1. Pega a posição do alvo atual.
	#var target_position = waypoints[current_waypoint_index]
	## 2. Verifica a distância até o alvo.
	#var distance_to_target = host.global_position.distance_to(target_position)
	## 3. Se o chefe chegou perto o suficiente do ponto...
	#if distance_to_target < arrival_threshold:
		## ...avança para o próximo ponto no ciclo.
		#current_waypoint_index = (current_waypoint_index + 1) % waypoints.size()
		## TODO: Implementar a lógica do Autômato Rúnico (Runic Automaton) aqui.
		## Quando o chefe alcança um waypoint, deve ativar a runa correspondente.
		## Possível implementação: emitir um sinal para o chefe ativar a runa, ex:
		## host.emit_signal("rune_activated", current_waypoint_index)
		## Detalhes:
		## - Cada waypoint pode estar associado a uma runa específica.
		## - A ativação pode envolver efeitos visuais, mudanças de estado, ou buffs/debuffs.
		## - Consulte o design do Autômato Rúnico para requisitos específicos.
		## - Veja o issue tracker para detalhes: https://example.com/issues/automato-runico
		## Atualiza o alvo para o novo ponto.
		#target_position = waypoints[current_waypoint_index]
	## 4. Move o chefe em direção ao alvo.
	#var direction = host.global_position.direction_to(target_position)
	#host.velocity = direction * patrol_speed
	#host.move_and_slide()
