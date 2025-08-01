# ActivateBulletComponent.gd
class_name ActivateBulletComponent
extends Node

@export_group("Settings")
@export var activator_shot_scene: PackedScene
@export var cooldown_time: float = 1.0

# --- Referências de Nós ---
@onready var owner_player: CharacterBody2D = owner
@onready var input_component: InputComponent = owner.get_node("InputComponent")
@onready var animation_component: AnimationComponent = owner.get_node("AnimationComponent")
@onready var player_animation_player: AnimationPlayer = owner.get_node("Sprite2D/AnimationPlayer")
@onready var cooldown_timer: Timer = $CooldownTimer

# --- Variáveis de Estado ---
var can_fire: bool = true
var is_charging: bool = false

func _ready():
	player_animation_player.animation_finished.connect(_on_animation_finished)
	cooldown_timer.timeout.connect(_on_cooldown_timer_timeout)

func _process(_delta):
	# Se o jogador soltar a tecla enquanto carrega, cancela a ação
	if is_charging and input_component.activate_bullet_released:
		cancel_charge()
		return # Sai da função para evitar outros inputs no mesmo frame

	# Se a ação for pressionada, o jogador puder atirar e não estiver já carregando...
	if input_component.activate_bullet_pressed and can_fire and not is_charging:
		is_charging = true
		animation_component.handle_charge_shot_animation()

# Chamado quando a animação de carregar TERMINA (o jogador não cancelou)
func _on_animation_finished(anim_name):
	if anim_name == "charge_shot":
		# Só dispara se ainda estiver no estado de carregamento
		if is_charging:
			fire_activator_shot()
			is_charging = false
			#can_fire = false
			cooldown_timer.start(cooldown_time)

# --- NEW FUNCTION ---
# Cancela o carregamento do tiro
func cancel_charge():
	is_charging = false
	# Para a animação e a reseta para o início.
	# O script do Player vai tratar de voltar para a animação de "parado".
	player_animation_player.stop(true)

func fire_activator_shot():
	var bullet_instance = TowerManager.get_bullet_instance()
	if not is_instance_valid(bullet_instance):
		return
		
	if not activator_shot_scene:
		push_error("A cena do ActivatorShot não foi definida no Inspector!")
		return
		
	var shot = activator_shot_scene.instantiate() as ActivatorShot
	shot.global_position = owner_player.global_position
	shot.target = bullet_instance
	get_tree().current_scene.add_child(shot)

func _on_cooldown_timer_timeout():
	can_fire = true
