extends CharacterBody2D

@export_subgroup("Components")
@export var input_component: InputComponent
@export var movement_component: MovementComponent
@export var animation_component: AnimationComponent
@export var roll_component: RollComponent
@export var activate_bullet_component: ActivateBulletComponent
@export var hurtbox_component: HurtboxComponent
@export var camera_component: CameraComponent
@export var audio_component: AudioComponent

@export var health_ui: HealthUI

@export var actual_camera: Camera2D
@export var game_over_scene: PackedScene

@onready var roll_timer: Timer = $RollTimer
@onready var ghost_timer: Timer = $GhostTimer
@onready var step_timer: Timer = $StepTimer

var can_roll = true

func _ready():
	camera_component.camera = actual_camera
	$Sprite2D.material.set_shader_parameter('hit_flash_on', false)
	if hurtbox_component:
		hurtbox_component.died.connect(_on_died)
	if health_ui:
		# 1. Espere o nó da UI emitir o sinal de que está pronto.
		# Isso pausa a execução aqui até que a UI esteja 100% carregada.
		await health_ui.ready

		# 2. Agora que temos certeza que a UI está pronta, podemos conectar os sinais.
		hurtbox_component.health_changed.connect(
			func(current_hp, max_hp): health_ui.update_hearts(current_hp / 10)
		)
		
		# 3. E agora podemos chamar a função de atualização inicial com segurança.
		health_ui.update_hearts(hurtbox_component.current_health / 10)

func _physics_process(delta: float) -> void:
	
	# A hierarquia de estados do jogador: Carregar Tiro > Rolar > Mover
	# Player state hierarchy: Charge Shot > Roll > Move
	# Each higher-priority state prevents execution of lower-priority ones.

	# 1. ESTADO: CARREGAR O TIRO (MAIOR PRIORIDADE)
	if activate_bullet_component.is_charging:
		movement_component.handle_movement(self, Vector2.ZERO)
		
		move_and_slide()
		return # Impede qualquer outra ação
	else:
		animation_component.toggle_charge_animation_sprites(false)
	
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
		hurtbox_component.deactivate()
		set_collision_layer_value(9, false)
		can_roll = false
		roll_component._dodge_roll(input_component.direction)
		animation_component.handle_roll_animation(input_component.direction, roll_component.dodge_duration)
		roll_timer.start(roll_component.dodge_duration + 0.1)
	else:
		hurtbox_component.activate()
		set_collision_layer_value(9, true)
		
		# Se não rolou, executa o movimento normal
		
		if input_component.direction != Vector2.ZERO:
			if step_timer.is_stopped():
				step_timer.start()
		
		movement_component.handle_movement(self, input_component.direction)
		animation_component.handle_move_animation(self, input_component.direction)

	move_and_slide()
	

func _on_died():
	# 1. Imediatamente para toda a lógica de controle do jogador.
	set_physics_process(false)
	# Desativa a colisão do corpo do jogador para evitar interações estranhas.
	set_collision_layer_value(1, false)
	set_collision_mask_value(1, false)

	# 2. Chama a função de animação de morte no componente de animação.
	#animation_component.handle_death_animation()

	# 3. Espera a animação terminar.
	#await animation_component.sprite.animation_finished

	# 4. Muda para a cena de Game Over.
	if game_over_scene:
		get_tree().change_scene_to_packed(game_over_scene)
	else:
		# Fallback caso nenhuma cena seja definida
		print("GAME OVER! Nenhuma cena de Game Over foi definida.")
		get_tree().quit()

func _on_roll_timer_timeout() -> void:
	can_roll = true

func _on_ghost_timer_timeout() -> void:
	animation_component.add_ghost(self, input_component.direction)


func _on_step_timer_timeout() -> void:
	audio_component.play_audio_stream("passos", Vector2(0.8, 1.2))
