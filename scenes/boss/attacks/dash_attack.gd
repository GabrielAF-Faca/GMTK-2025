# DashAttack.gd
class_name DashAttack
extends BossAttack

@export_group("Dash Settings")
# A velocidade do dash
@export var dash_speed: float = 900.0
# O tempo de preparação antes do dash
@export var telegraph_duration: float = 0.6
# A animação que toca durante a preparação
@export var telegraph_animation: String = "idle"
# A animação que toca durante o dash
@export var dash_animation: String = "attack" # Usando a animação de ataque como placeholder

func execute(host: Boss, attack_component: AttackComponent):
	# Inicia a sequência do dash
	_start_dash_sequence(host, attack_component)

func _start_dash_sequence(host: Boss, attack_component: AttackComponent):
	# Pega a referência do jogador
	var player = host.get_player_reference()
	if not is_instance_valid(player):
		attack_component.finish_attack_manually()
		return

	# Fase 1: Preparação (Telegraph)
	host.animation_component.handle_attack_animation(telegraph_animation, false)
	host.animation_component.face_target(host, player)
	
	# Espera o tempo de preparação
	await host.get_tree().create_timer(telegraph_duration).timeout
	print("Dando dash")
	# Fase 2: Execução do Dash
	# Calcula a direção para o jogador no momento em que o dash começa
	var dash_direction = host.global_position.direction_to(player.global_position)#(player.global_position - host.global_position).normalized()
	
	#host.velocity = dash_direction * dash_speed
	
	# Define as propriedades no AttackComponent para que o script do boss possa gerir o movimento
	attack_component.charge_direction = dash_direction
	attack_component.charge_speed = dash_speed
	attack_component.is_charging = true # Usamos a mesma flag do charge attack
	
	attack_component.handle_charge_attack(1)
	
	# Toca a animação do dash
	host.animation_component.handle_attack_animation(dash_animation, true)
