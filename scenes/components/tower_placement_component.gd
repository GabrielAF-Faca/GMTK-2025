# TowerPlacementComponent.gd
class_name TowerPlacementComponent
extends Node

@export_group("Throw Settings")
@export var min_throw_force: float = 75.0
@export var max_throw_force: float = 350.0
@export var charge_speed: float = 250.0

@export_group("Scene References")
# Arraste sua cena Tower.tscn para este campo no Inspector do Godot
@export var tower_scene: PackedScene

# --- Variáveis para o feedback visual ---
@onready var held_tower_sprite: Sprite2D = $HeldTowerSprite

# --- Variáveis de Estado ---
var towers_placed_count: int = 0
var held_tower: Tower = null
var nearby_towers: Array[Tower] = []

# --- Variáveis de Carregamento ---
var trajectory_preview: Line2D
var is_charging: bool = false
var current_throw_force: float = 0.0
var force_increasing: bool = true

# --- Referências de Nós ---
var owner_player: CharacterBody2D
var interaction_area: Area2D
var animation_component: AnimationComponent
var input_component: InputComponent

func _ready():
	trajectory_preview = Line2D.new()
	trajectory_preview.width = 3.0
	trajectory_preview.default_color = Color(1, 1, 1, 0.5)
	var gradient = Gradient.new()
	gradient.set_colors([Color.WHITE, Color(1,1,1,0)])
	trajectory_preview.gradient = gradient
	trajectory_preview.hide()

	await owner.ready
	
	owner_player = owner as CharacterBody2D
	interaction_area = owner_player.get_node("InteractionArea")
	animation_component = owner_player.get_node("AnimationComponent")
	input_component = owner_player.get_node("InputComponent")
	
	owner_player.add_child(trajectory_preview)

	if not interaction_area or not animation_component or not input_component:
		push_error("Um ou mais componentes não foram encontrados no Player.")
		return
	
	if not held_tower_sprite:
		push_error("O nó 'HeldTowerSprite' não foi encontrado como filho deste componente.")
		return
	
	held_tower_sprite.hide()

	interaction_area.area_entered.connect(_on_interaction_area_entered)
	interaction_area.area_exited.connect(_on_interaction_area_exited)

func _process(delta: float):
	if not is_instance_valid(owner_player):
		return
		
	# Verifica em qual "modo" o jogador está
	if towers_placed_count < 2:
		# MODO 1: Criação das torres com arremesso
		handle_initial_creation(delta)
	else:
		# MODO 2: Reposicionamento das torres existentes (sem arremesso)
		handle_repositioning()

# Lida com a criação e arremesso das duas primeiras torres
func handle_initial_creation(delta: float):
	if input_component.interact_just_pressed and not is_charging:
		is_charging = true
		current_throw_force = min_throw_force
		force_increasing = true
	
	if is_charging and input_component.interact_pressed:
		update_throw_force(delta)
		update_trajectory_preview()
		trajectory_preview.show()
		
	if is_charging and input_component.interact_just_released:
		is_charging = false
		trajectory_preview.hide()
		create_and_throw_new_tower()

# Lida com pegar e soltar as torres já existentes
func handle_repositioning():
	if held_tower:
		# Se está segurando uma torre, solta ela na posição atual com um clique
		held_tower_sprite.global_position = owner_player.global_position + Vector2(0, -30)
		if input_component.interact_just_pressed:
			drop_tower_at_feet()
	elif nearby_towers.size() > 0 and input_component.interact_just_pressed:
		# Se não está segurando e está perto de uma, pega ela
		pickup_tower(nearby_towers[0])

# Lógica do "ping-pong" da força
func update_throw_force(delta: float):
	if force_increasing:
		current_throw_force += charge_speed * delta
		if current_throw_force >= max_throw_force:
			current_throw_force = max_throw_force
			force_increasing = false
	else:
		current_throw_force -= charge_speed * delta
		if current_throw_force <= min_throw_force:
			current_throw_force = min_throw_force
			force_increasing = true

# Cria uma nova torre e a arremessa
func create_and_throw_new_tower():
	if not tower_scene:
		push_error("A cena da Torre (Tower Scene) não foi definida no Inspector!")
		return
		
	var new_tower = tower_scene.instantiate() as Tower
	get_tree().current_scene.add_child(new_tower) # Adiciona à cena primeiro
	
	var direction = animation_component.last_dir
	if direction == Vector2.ZERO:
		direction = Vector2.RIGHT
		
	var throw_position = owner_player.global_position + direction * current_throw_force
	new_tower.global_position = throw_position
	
	# Em vez de só mostrar, chama a nova função de animação
	new_tower.play_spawn_animation()
	
	TowerManager.register_tower(new_tower)
	towers_placed_count += 1

# Pega uma torre existente
func pickup_tower(tower: Tower):
	held_tower = tower
	TowerManager.unregister_tower(tower)
	tower.hide()
	held_tower_sprite.show()
	nearby_towers.erase(tower)

# Solta a torre nos pés do jogador
func drop_tower_at_feet():
	if not held_tower:
		return
		
	held_tower.global_position = owner_player.global_position
	held_tower.show() # Mostra a torre para que a animação possa ser executada
	
	# Chama a nova função de animação
	held_tower.play_spawn_animation()
	
	TowerManager.register_tower(held_tower)
	
	held_tower = null
	held_tower_sprite.hide()

func update_trajectory_preview():
	var direction = animation_component.last_dir
	if direction == Vector2.ZERO:
		direction = Vector2.RIGHT
		
	var start_point = Vector2.ZERO
	var end_point = direction * current_throw_force
	
	trajectory_preview.clear_points()
	trajectory_preview.add_point(start_point)
	trajectory_preview.add_point(end_point)

func _on_interaction_area_entered(area: Area2D):
	if area is Tower and not nearby_towers.has(area) and area != held_tower:
		nearby_towers.append(area)

func _on_interaction_area_exited(area: Area2D):
	if area is Tower and nearby_towers.has(area):
		nearby_towers.erase(area)
