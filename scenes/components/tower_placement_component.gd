# TowerPlacementComponent.gd
class_name TowerPlacementComponent
extends Node

@export_group("Throw Settings")
# Novas variáveis para controlar a força do arremesso
@export var min_throw_force: float = 5.0
@export var max_throw_force: float = 100.0
@export var charge_speed: float = 250.0 # Pontos de força por segundo

# Referência para a torre que o jogador está segurando
var held_tower: Area2D = null
# Referência para as torres que estão próximas ao jogador
var nearby_towers: Array[Area2D] = []

# Nó que mostrará a prévia da trajetória do arremesso
var trajectory_preview: Line2D

# Variáveis de estado para o carregamento
var is_charging: bool = false
var current_throw_force: float = 0.0

# Referências aos outros nós e componentes
var owner_player: CharacterBody2D
var interaction_area: Area2D
var animation_component: AnimationComponent
var input_component: InputComponent

func _ready():
	await owner.ready
	
	owner_player = owner as CharacterBody2D
	interaction_area = owner_player.get_node("InteractionArea")
	animation_component = owner_player.get_node("AnimationComponent")
	input_component = owner_player.get_node("InputComponent")

	if not interaction_area or not animation_component or not input_component:
		push_error("Um ou mais componentes não foram encontrados no Player.")
		return

	interaction_area.area_entered.connect(_on_interaction_area_entered)
	interaction_area.area_exited.connect(_on_interaction_area_exited)
	
	trajectory_preview = Line2D.new()
	trajectory_preview.width = 3.0
	trajectory_preview.default_color = Color(1, 1, 1, 0.5)
	var gradient = Gradient.new()
	gradient.set_colors([Color.WHITE, Color(1,1,1,0)])
	trajectory_preview.gradient = gradient
	owner_player.add_child(trajectory_preview)
	trajectory_preview.hide()

var force_increasing = true

func _process(delta: float):
	if not is_instance_valid(owner_player):
		return
		
	# Lógica de input baseada em estados (pegar, carregar, atirar)
	if held_tower:
		# Inicia o carregamento
		if input_component.interact_just_pressed and not is_charging:
			is_charging = true
			force_increasing = true
			current_throw_force = min_throw_force
		
		# Enquanto carrega, aumenta a força e atualiza a pré-visualização
		if is_charging and input_component.interact_pressed:
			if force_increasing:
				current_throw_force = min(current_throw_force + charge_speed * delta, max_throw_force)
				if ((current_throw_force + charge_speed * delta) > max_throw_force):
					force_increasing = false
			else:
				current_throw_force = max(min_throw_force, min(current_throw_force - charge_speed * delta, max_throw_force))
				if ((current_throw_force - charge_speed * delta) < min_throw_force):
					force_increasing = true
			update_trajectory_preview()
			trajectory_preview.show()
			
		# Solta a tecla para atirar
		if is_charging and input_component.interact_just_released:
			is_charging = false
			trajectory_preview.hide()
			throw_tower()
			
	# Se não estiver a segurar uma torre, verifica se pode pegar uma
	elif nearby_towers.size() > 0 and input_component.interact_just_pressed:
		pickup_tower(nearby_towers[0])

func pickup_tower(tower: Tower):
	held_tower = tower
	TowerManager.unregister_tower(tower)
	tower.hide()
	nearby_towers.erase(tower)

func throw_tower():
	if not held_tower:
		return
		
	var direction = animation_component.last_dir
	if direction == Vector2.ZERO:
		direction = Vector2.RIGHT
		
	# Usa a força carregada em vez de uma distância fixa
	var throw_position = owner_player.global_position + direction * current_throw_force
	
	held_tower.global_position = throw_position
	held_tower.show()
	
	TowerManager.register_tower(held_tower)
	
	held_tower = null

func update_trajectory_preview():
	var direction = animation_component.last_dir
	if direction == Vector2.ZERO:
		direction = Vector2.RIGHT
		
	var start_point = Vector2.ZERO
	# O ponto final da linha agora usa a força atual
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
