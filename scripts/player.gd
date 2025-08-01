extends CharacterBody2D

@export_subgroup("Components")
@export var input_component: InputComponent
@export var movement_component: MovementComponent
@export var animation_component: AnimationComponent
@export var roll_component: RollComponent
@export var activate_bullet_component: ActivateBulletComponent

@onready var roll_timer: Timer = $RollTimer
@onready var ghost_timer: Timer = $GhostTimer

var can_roll = true

func _physics_process(delta: float) -> void:
	
	# A hierarquia de estados do jogador: Carregar Tiro > Rolar > Mover
	# Player state hierarchy: Charge Shot > Roll > Move
	# Each higher-priority state prevents execution of lower-priority ones.

	# 1. ESTADO: CARREGAR O TIRO (MAIOR PRIORIDADE)
	if activate_bullet_component.is_charging:
		movement_component.handle_movement(self, Vector2.ZERO)
		move_and_slide()
		return # Impede qualquer outra ação

	# 2. ESTADO: ROLAR
	if roll_component.rolling:
		roll_component.handle_roll_movement(self, delta)
		if ghost_timer.is_stopped():
			ghost_timer.start()
		move_and_slide()
		return # Impede o movimento normal

	# 3. ESTADO: MOVIMENTO NORMAL (MENOR PRIORIDADE)
	# Esta parte só é executada se o jogador não estiver nem a carregar nem a rolar.
	
	# Tenta iniciar um rolamento
	if input_component.roll and can_roll:
		can_roll = false
		roll_component._dodge_roll(input_component.direction)
		animation_component.handle_roll_animation(input_component.direction, roll_component.dodge_duration)
		roll_timer.start(roll_component.dodge_duration + 0.1)
	else:
		# Se não rolou, executa o movimento normal
		movement_component.handle_movement(self, input_component.direction)
		animation_component.handle_move_animation(input_component.direction)

	move_and_slide()

func _on_roll_timer_timeout() -> void:
	can_roll = true

func _on_ghost_timer_timeout() -> void:
	animation_component.add_ghost(self, input_component.direction)
