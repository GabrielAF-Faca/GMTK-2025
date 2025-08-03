# ActivateBulletComponent.gd
class_name ActivateBulletComponent
extends Node

@export_group("Settings")
@export var activator_shot_scene: PackedScene
@export var cooldown_time: float = 1.0
@export var tiro_sprite: AnimatedSprite2D

# --- Referências de Nós ---
@onready var owner_player: CharacterBody2D = owner
@onready var input_component: InputComponent = owner.get_node("InputComponent")
@onready var animation_component: AnimationComponent = owner.get_node("AnimationComponent")
@onready var player_animation_player: AnimationPlayer = owner.get_node("Sprite2D/AnimationPlayer")
@onready var cooldown_timer: Timer = $CooldownTimer

# --- Variáveis de Estado ---
var can_fire: bool = true
var is_charging: bool = false
var fire: bool = false
var tween: Tween
var pode_barulhinho: bool = true

func _ready():
	player_animation_player.animation_finished.connect(_on_animation_finished)
	cooldown_timer.timeout.connect(_on_cooldown_timer_timeout)
	reset_tiro_sprite()
	
func reset_tiro_sprite():
	tiro_sprite.visible = false
	tiro_sprite.modulate = Color(1.0, 1.0, 1.0, 0.0)
	tiro_sprite.scale = Vector2(0,0)
	tiro_sprite.stop()
	pode_barulhinho = true

func show_tiro_fake():
	
	if pode_barulhinho:
		pode_barulhinho = false
		owner_player.audio_component.play_audio_stream("pode_atirar")
	
	if tween and tween.is_running():
		tween.kill()
	
	tiro_sprite.visible = true
	tween = create_tween()
	tween.tween_property(tiro_sprite, "modulate", Color(1.0, 1.0, 1.0), 0.1)
	tween.set_parallel(true)
	tween.tween_property(tiro_sprite, "scale", Vector2(1, 1), 0.1)
	tween.set_ease(Tween.EASE_IN_OUT)
	tween.set_trans(Tween.TRANS_CUBIC)
	tween.play()
	tiro_sprite.play("default")

func _process(_delta):
	if fire and input_component.activate_bullet_released:
		is_charging = false
		fire = false
		fire_activator_shot()
		cooldown_timer.start(cooldown_time)
	
	if fire and is_charging:
		var bullet_instance = TowerManager.get_bullet_instance()
		if is_instance_valid(bullet_instance):
			show_tiro_fake()
			
			tiro_sprite.rotation = owner.global_position.angle_to_point(bullet_instance.global_position)
			
	# Se o jogador soltar a tecla enquanto carrega, cancela a ação
	if is_charging and input_component.activate_bullet_released:
		cancel_charge()
		return # Sai da função para evitar outros inputs no mesmo frame

	# Se a ação for pressionada, o jogador puder atirar e não estiver já carregando...
	if input_component.activate_bullet_pressed and can_fire and not is_charging:
		is_charging = true
		owner_player.audio_component.play_audio_stream("casting")
		animation_component.handle_charge_shot_animation()

# Chamado quando a animação de carregar TERMINA (o jogador não cancelou)
func _on_animation_finished(anim_name):
	if anim_name == "charge_shot":
		# Só dispara se ainda estiver no estado de carregamento
		if is_charging:
			fire = true
			#can_fire = false
			
# --- NEW FUNCTION ---
# Cancela o carregamento do tiro
func cancel_charge():
	owner_player.audio_component.stop_audio_stream("casting")
	is_charging = false
	# Para a animação e a reseta para o início.
	# O script do Player vai tratar de voltar para a animação de "parado".
	player_animation_player.stop(true)

func fire_activator_shot():
	owner_player.audio_component.stop_audio_stream("casting")
	owner_player.audio_component.play_audio_stream("firing")
	
	reset_tiro_sprite()
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
