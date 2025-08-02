# charge_attack.gd
class_name ChargeAttack
extends BossAttack

@export var charge_speed: float = 800.0
@export var charge_up_duration: float = 0.5
@export var telegraph_animation: String = "idle"
@export var charge_animation: String = "walk"

# --- NOVAS VARIÁVEIS ---
# Duração do atordoamento em segundos após colidir com uma parede.
@export var stun_duration_on_hit: float = 0.7
# Animação para tocar quando o chefe estiver atordoado.
@export var stun_animation: String = "idle"
# -------------------------

func execute(host: Boss, attack_component: AttackComponent) -> void:
	if not host.has_method("get_player_reference"):
		print("ERRO: O script do chefe precisa de uma referência ao player.")
		return
		
	var player = host.get_player_reference()
	if not is_instance_valid(player):
		print("ERRO: Referência do player é inválida.")
		return

	_start_charge_sequence(host, player)

func _start_charge_sequence(host: Boss, player: Node2D) -> void:
	host.animation_component.handle_attack_animation(telegraph_animation, false)
	host.animation_component.face_target(host, player)

	
	await host.get_tree().create_timer(charge_up_duration).timeout

	var charge_direction = (player.global_position - host.global_position).normalized()
	
	host.charge_direction = charge_direction
	host.charge_speed = charge_speed
	host.is_charging = true
	
	host.animation_component.handle_attack_animation(charge_animation, true)
