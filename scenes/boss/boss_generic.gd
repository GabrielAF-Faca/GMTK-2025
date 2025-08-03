class_name Boss
extends CharacterBody2D

@export var state_machine: StateMachine
@export var movement_component: MovementComponent
@export var attack_component: AttackComponent
@export var animation_component: AnimationComponent
@export var hurtbox_component: HurtboxComponent
@export var hitbox_component: HitboxComponent
@export var audio_component: AudioComponent

@export var player: CharacterBody2D
@export var standing_points: Node2D

@onready var stun_timer: Timer = $StunTimer
@onready var step_timer: Timer = $StepTimer
@onready var animated_sprite: AnimatedSprite2D = $AnimatedSprite2D

# --- VARIÁVEIS DE MOVIMENTO ---
var move_direction: Vector2 = Vector2.ZERO

# -----------------------------
@export var win_scene: PackedScene
#signal change_scene_requested(scene_to_load: PackedScene)

# --- VARIÁVEIS DE ATAQUE FORAM REMOVIDAS DAQUI ---
# A lógica de 'is_charging', 'charge_direction' e 'charge_speed'
# foi movida para o AttackComponent.
# -------------------------------------------------


func _ready() -> void:
	stun_timer.timeout.connect(_on_stun_timer_timeout)
	#step_timer.timeout.connect(_on_step_timer_timeout)
	
	if hurtbox_component:
		hurtbox_component.died.connect(_on_died)

func _on_died():
	print("%s morreu!" % self.name)
	set_physics_process(false) # Para o loop de física deste script.
	state_machine.set_process(false) # Para a máquina de estados.
	attack_component.finish_attack_manually() # Cancela qualquer ataque em andamento.
	# Aqui você pode parar a máquina de estados, tocar uma animação de morte, etc.
	animated_sprite.play("die")
	await  animated_sprite.animation_finished
	var torres = get_tree().get_nodes_in_group("Torres")
	if torres:
		for torre in torres:
			TowerManager.unregister_tower(torre)
	#change_scene_requested.emit(win_scene)
	get_tree().change_scene_to_packed(win_scene)
	queue_free() # Exemplo: remove o boss da cena.

func _physics_process(delta: float) -> void:
	
	if not attack_component.attacking:
		# Se não está atacando, lida com o movimento normal.
		if step_timer.is_stopped() and not is_instance_of(state_machine.current_state, IdleState) and state_machine.current_state:
			step_timer.start()
		movement_component.handle_movement(self, move_direction)
		animation_component.handle_move_animation(self, velocity)
		
	else:
		# Se está atacando, verifica se é um charge attack.
		if attack_component.current_attack is ChargeAttack:
			# Delega toda a lógica da investida para o componente.
			attack_component.handle_charge_attack(delta)
		else:
			# Para outros tipos de ataque, o chefe simplesmente para.
			# Você pode adicionar outras lógicas aqui se necessário.
			movement_component.handle_movement(self, Vector2.ZERO)
			
	move_and_slide()

# Chamado quando o timer de stun termina.
func _on_stun_timer_timeout():
	# Força o fim do estado de ataque através do componente.
	attack_component.finish_attack_manually()

# Função para os ataques obterem a referência do player.
func get_player_reference() -> CharacterBody2D:
	return player

func _on_step_timer_timeout() -> void:
	audio_component.play_audio_stream("andando")
