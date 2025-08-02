class_name Boss
extends CharacterBody2D

@export var state_machine: StateMachine
@export var movement_component: MovementComponent
@export var attack_component: AttackComponent
@export var animation_component: AnimationComponent
@export var player: CharacterBody2D

@export var standing_points: Node2D

# --- NOVAS VARIÁVEIS ---
@onready var stun_timer: Timer = $StunTimer
# -----------------------

# --- VARIÁVEIS DE MOVIMENTO ---
var move_direction: Vector2 = Vector2.ZERO
# -----------------------------

# --- VARIÁVEIS DE ATAQUE ---
var is_charging: bool = false
var charge_direction: Vector2 = Vector2.ZERO
var charge_speed: float = 0.0
# ---------------------------

func _ready() -> void:
	# Conecta o sinal do timer de stun.
	stun_timer.timeout.connect(_on_stun_timer_timeout)

func _physics_process(delta: float) -> void:
	
	if not attack_component.attacking:
		movement_component.handle_movement(self, move_direction)
		animation_component.handle_move_animation(self, velocity)
	else:
		if is_charging:
			animation_component.add_ghost(self, move_direction)
			self.velocity = charge_direction * charge_speed
			
			var collision = get_last_slide_collision()
			# Se colidiu e não está já atordoado...
			if collision and stun_timer.is_stopped():
				
				# --- LÓGICA DE COLISÃO ATUALIZADA ---
				# Esta lógica agora é acionada ao colidir com qualquer corpo físico,
				# seja o jogador ou uma parede.
				# NOTA: Para que a colisão com o jogador funcione, certifique-se de que
				# as Camadas de Colisão (Collision Layers) e Máscaras (Masks) do chefe
				# e do jogador estão configuradas para interagir entre si no Inspetor.
				
				is_charging = false
				
				# Para o timer principal do ataque.
				attack_component.stop_attack_timer()
				
				# Pega a duração e a animação do recurso de ataque atual.
				var charge_attack = attack_component.current_attack as ChargeAttack
				if charge_attack:
					stun_timer.wait_time = charge_attack.stun_duration_on_hit
					animation_component.handle_attack_animation(charge_attack.stun_animation, false)

				stun_timer.start()
		else:
			movement_component.handle_movement(self, Vector2.ZERO)
			
	move_and_slide()

# Chamado quando o timer de stun termina.
func _on_stun_timer_timeout():
	# Força o fim do estado de ataque.
	attack_component.finish_attack_manually()

# Função para os ataques obterem a referência do player.
func get_player_reference() -> CharacterBody2D:
	return player
