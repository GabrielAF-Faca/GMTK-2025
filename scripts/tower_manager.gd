# TowerManager.gd
extends Node

# Referências para as cenas que vamos instanciar
const PathManager = preload("res://scenes/path_manager.tscn")
const Bullet = preload("res://scenes/bullet.tscn")

# Array para guardar as referências das torres posicionadas no mundo
var active_towers: Array[Node2D] = []

# Referência para o nosso gerenciador de caminho
var path_manager_instance: Node = null
var bullet_instance: Bullet = null # Changed to Bullet type to access its methods

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
	
	var distance = tower1_pos.distance_to(tower2_pos)
	var angle = tower1_pos.angle_to_point(tower2_pos)
	
	var control_offset = Vector2(0, distance / 2.5).rotated(angle)
	
	var curve = Curve2D.new()
	curve.add_point(tower1_pos, -control_offset, control_offset)
	curve.add_point(tower2_pos, control_offset, -control_offset)
	curve.add_point(tower2_pos, control_offset, -control_offset)
	curve.add_point(tower1_pos, -control_offset, control_offset)
	
	path_node.curve = curve
	
	if not is_instance_valid(bullet_instance):
		var path_follow_node: PathFollow2D = path_node.get_node("PathFollow2D")
		bullet_instance = Bullet.instantiate()
		path_follow_node.add_child(bullet_instance)
		
		# --- IMPORTANT CHANGE ---
		# --- IMPORTANT CHANGE ---
		# Forces the bullet to start in Cooldown state
		bullet_instance.change_state(bullet_instance.State.COOLDOWN)
		
		path_follow_node.loop = true
		
		var tween = get_tree().create_tween().set_loops()
		tween.tween_property(path_follow_node, "progress_ratio", 1.0, 5.0).from(0.0)

func destroy_path():
	if is_instance_valid(path_manager_instance):
		path_manager_instance.queue_free()
		path_manager_instance = null
		bullet_instance = null

# --- Functions we already had ---
func activate_bullet():
	if is_instance_valid(bullet_instance):
		bullet_instance.activate()

func get_bullet_global_position() -> Vector2:
	if is_instance_valid(bullet_instance):
		return bullet_instance.global_position
	return Vector2.INF

func get_bullet_instance() -> Node2D:
	if is_instance_valid(bullet_instance):
		return bullet_instance
	return null
