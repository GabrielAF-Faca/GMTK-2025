class_name Boss
extends CharacterBody2D

@export var state_machine: StateMachine
@export var movement_component: MovementComponent
@export var attack_component: AttackComponent
@export var animation_component: AnimationComponent
@export var player: CharacterBody2D

@export var standing_points: Node2D

# --- VARIÁVEIS DE MOVIMENTO ---
var move_direction: Vector2 = Vector2.ZERO
# -----------------------------

# --- VARIÁVEIS DE ATAQUE ---
var is_charging: bool = false
var charge_direction: Vector2 = Vector2.ZERO
var charge_speed: float = 0.0
# ---------------------------

func _physics_process(delta: float) -> void:
	
	if not attack_component.attacking:
		# Se não estiver atacando, usa o MoveComponent para o movimento padrão.
		# O 'move_direction' é controlado pelo estado atual (ex: PatrolState).
		movement_component.handle_movement(self, move_direction)
		animation_component.handle_move_animation(self, velocity)
	else:
		# Se estiver atacando, a lógica de movimento é específica do ataque.
		if is_charging:
			# Para o ChargeAttack, usamos uma lógica de movimento especial.
			# O MoveComponent pode ser usado aqui também, se ele puder lidar com velocidades customizadas.
			# Por simplicidade, definimos a velocidade diretamente.
			self.velocity = charge_direction * charge_speed
		else:
			# Para ataques parados (como melee), dizemos ao MoveComponent para parar.
			movement_component.handle_movement(self, Vector2.ZERO)
			
	move_and_slide()

# Função para os ataques obterem a referência do player.
func get_player_reference() -> CharacterBody2D:
	return player
