# TowerPlacementComponent.gd
class_name TowerPlacementComponent
extends Node

@export_group("Throw Settings")
@export var min_throw_force: float = 15.0
@export var max_throw_force: float = 150.0
@export var charge_speed: float = 250.0

# --- Variáveis para o feedback visual ---
# Referência para o sprite que aparece quando o jogador segura uma torre
@onready var held_tower_sprite: Sprite2D = $HeldTowerSprite
# ------------------------------------

var held_tower: Tower = null
var nearby_towers: Array[Tower] = []
var trajectory_preview: Line2D
var is_charging: bool = false
var current_throw_force: float = 0.0

# --- Nova variável para a lógica de "ping-pong" ---
var force_increasing: bool = true
# ------------------------------------------------

var owner_player: CharacterBody2D
var interaction_area: Area2D
var animation_component: AnimationComponent
var input_component: InputComponent

func _ready():
	# Inicializa a linha de previsão para evitar erros
	trajectory_preview = Line2D.new()
	trajectory_preview.width = 3.0
	trajectory_preview.default_color = Color(1, 1, 1, 0.5)
	var gradient = Gradient.new()
	gradient.set_colors([Color.WHITE, Color(1,1,1,0)])
	trajectory_preview.gradient = gradient
	trajectory_preview.hide()

	# Espera o "dono" (Player) estar pronto
	await owner.ready
	
	owner_player = owner as CharacterBody2D
	interaction_area = owner_player.get_node("InteractionArea")
	animation_component = owner_player.get_node("AnimationComponent")
	input_component = owner_player.get_node("InputComponent")
	
	# Adiciona a linha de previsão como filha do player
	owner_player.add_child(trajectory_preview)

	# Validação dos nós necessários
	if not interaction_area or not animation_component or not input_component:
		push_error("Um ou mais componentes não foram encontrados no Player.")
		return
	
	if not held_tower_sprite:
		push_error("O nó 'HeldTowerSprite' não foi encontrado como filho deste componente.")
		return
	
	held_tower_sprite.hide()

	# Conecta os sinais da área de interação
	interaction_area.area_entered.connect(_on_interaction_area_entered)
	interaction_area.area_exited.connect(_on_interaction_area_exited)

func _process(delta: float):
	if not is_instance_valid(owner_player):
		return
		
	# Lógica de Input simplificada
	# Se o jogador estiver segurando uma torre
	if held_tower:
		handle_charging_and_throwing(delta)
		# Força o sprite a seguir o jogador
		held_tower_sprite.global_position = owner_player.global_position + Vector2(0, -30)
	# Se não estiver segurando, verifica se pode pegar uma
	elif nearby_towers.size() > 0 and input_component.interact_just_pressed:
		pickup_tower(nearby_towers[0])

# Função para lidar com o carregamento e arremesso
func handle_charging_and_throwing(delta: float):
	# Inicia o carregamento
	if input_component.interact_just_pressed and not is_charging:
		is_charging = true
		current_throw_force = min_throw_force
		force_increasing = true # Garante que a força sempre comece a subir
	
	# Lógica de carregamento "ping-pong"
	if is_charging and input_component.interact_pressed:
		if force_increasing:
			current_throw_force += charge_speed * delta
			if current_throw_force >= max_throw_force:
				current_throw_force = max_throw_force
				force_increasing = false
		else: # A força está a diminuir
			current_throw_force -= charge_speed * delta
			if current_throw_force <= min_throw_force:
				current_throw_force = min_throw_force
				force_increasing = true
				
		update_trajectory_preview()
		trajectory_preview.show()
		
	# Solta a tecla para atirar
	if is_charging and input_component.interact_just_released:
		is_charging = false
		trajectory_preview.hide()
		throw_tower()

# Pega uma torre existente no mundo
func pickup_tower(tower: Tower):
	held_tower = tower
	TowerManager.unregister_tower(tower)
	tower.hide()
	held_tower_sprite.show() # Mostra o sprite de feedback
	nearby_towers.erase(tower)

# Arremessa a torre que estava sendo segurada
func throw_tower():
	if not held_tower:
		return
		
	var direction = animation_component.last_dir
	if direction == Vector2.ZERO:
		direction = Vector2.RIGHT
		
	var throw_position = owner_player.global_position + direction * current_throw_force
	
	held_tower.global_position = throw_position
	held_tower.show()
	
	TowerManager.register_tower(held_tower)
	
	held_tower = null
	held_tower_sprite.hide() # Esconde o sprite de feedback

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
