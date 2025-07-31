# TowerManager.gd
extends Node

# Referências para as cenas que vamos instanciar
const PathManager = preload("res://scenes/path_manager.tscn")
const Bullet = preload("res://scenes/bullet.tscn")

# Array para guardar as referências das torres posicionadas no mundo
var active_towers: Array[Node2D] = []

# Referência para o nosso gerenciador de caminho
var path_manager_instance: Node = null
var bullet_instance: Node = null

# Função para registrar uma torre quando ela é colocada no chão
func register_tower(tower: Node2D):
	if not active_towers.has(tower):
		active_towers.append(tower)
	
	# Se temos duas torres, criamos ou atualizamos o caminho
	if active_towers.size() == 2:
		create_or_update_path()

# Função para remover o registro de uma torre (quando o jogador a pega)
func unregister_tower(tower: Node2D):
	if active_towers.has(tower):
		active_towers.erase(tower)
	
	# Se não temos mais duas torres, destruímos o caminho e o projétil
	destroy_path()

func create_or_update_path():
	# Se não houver um gerenciador de caminho na cena, crie um.
	if not is_instance_valid(path_manager_instance):
		path_manager_instance = PathManager.instantiate()
		get_tree().current_scene.add_child(path_manager_instance)

	var path_node: Path2D = path_manager_instance.get_node("Path2D")
	
	# Define os pontos da curva
	var tower1_pos = active_towers[0].global_position
	var tower2_pos = active_towers[1].global_position
	
	# Calcula a distância e o ângulo para os pontos de controle da curva de Bézier
	# Isso criará a forma de "elipse"
	var distance = tower1_pos.distance_to(tower2_pos)
	var angle = tower1_pos.angle_to_point(tower2_pos)
	
	# Pontos de controle para criar a curvatura
	# O valor "distance / 1.5" define quão "gorda" a elipse será. Ajuste se necessário.
	var control_offset = Vector2(0, distance / 1.5).rotated(angle)
	
	var curve = Curve2D.new()
	# Curva de ida
	curve.add_point(tower1_pos, -control_offset, control_offset)
	curve.add_point(tower2_pos, control_offset, -control_offset)
	# Curva de volta
	curve.add_point(tower2_pos, control_offset, -control_offset) # Ponto de controle de saída da torre 2
	curve.add_point(tower1_pos, -control_offset, control_offset) # Ponto de controle de chegada na torre 1
	
	path_node.curve = curve
	
	# Se o projétil ainda não existe, crie e configure-o
	if not is_instance_valid(bullet_instance):
		var path_follow_node: PathFollow2D = path_node.get_node("PathFollow2D")
		bullet_instance = Bullet.instantiate()
		path_follow_node.add_child(bullet_instance)
		
		# Faz o projétil andar em loop no caminho
		path_follow_node.loop = true
		
		# Inicia a animação do progresso
		var tween = get_tree().create_tween().set_loops()
		# A duração do tween define a velocidade do projétil. 2 segundos para uma volta completa.
		tween.tween_property(path_follow_node, "progress_ratio", 1.0, 2.0).from(0.0)

func destroy_path():
	if is_instance_valid(path_manager_instance):
		path_manager_instance.queue_free()
		path_manager_instance = null
		bullet_instance = null
