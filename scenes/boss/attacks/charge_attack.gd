# charge_attack.gd
class_name ChargeAttack
extends BossAttack

## Velocidade do boss durante a investida.
@export var charge_speed: float = 800.0
## Tempo que o boss fica parado se preparando antes de avançar.
@export var charge_up_duration: float = 0.5
## Animação para tocar enquanto se prepara (ex: "charge_telegraph").
@export var telegraph_animation: String = "idle"
## Animação para tocar durante a investida (ex: "charge_dash").
@export var charge_animation: String = "walk"


# A função principal que inicia a sequência de ataque.
func execute(host: CharacterBody2D, attack_component: Node) -> void:
	# Garante que o host (chefe) tem as variáveis necessárias.
	if not host.has_method("get_player_reference"):
		print("ERRO: O script do chefe precisa de uma referência ao player.")
		return
		
	var player = host.get_player_reference()
	if not is_instance_valid(player):
		print("ERRO: Referência do player é inválida.")
		return

	# Inicia a corrotina para lidar com a sequência de ataque com pausas.
	_start_charge_sequence(host, player, attack_component)


# Usamos uma função assíncrona para lidar com as pausas.
func _start_charge_sequence(host: CharacterBody2D, player: Node2D, attack_component: Node) -> void:

	# --- FASE 1: Preparação (Telegraph) ---
	# Toca a animação de preparação.
	host.animation_component.handle_attack_animation(telegraph_animation, false) # Toca uma vez
	
	# Encara o jogador.
	host.animation_component.face_target(host, player)
	
	# Espera o tempo de preparação.
	await host.get_tree().create_timer(charge_up_duration).timeout

	# --- FASE 2: A Investida (Charge) ---
	# Calcula a direção para a investida UMA VEZ.
	var charge_direction = (player.global_position - host.global_position).normalized()
	
	# Informa ao script principal do chefe a direção e velocidade, e ativa a flag.
	host.charge_direction = charge_direction
	host.charge_speed = charge_speed
	host.is_charging = true
	
	# Toca a animação de investida.
	host.animation_component.handle_attack_animation(charge_animation, true) # Repete durante a investida
