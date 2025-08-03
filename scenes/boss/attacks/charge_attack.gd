# charge_attack.gd
class_name ChargeAttack
extends BossAttack

@export_group("Charge Settings")
@export var charge_speed: float = 800.0
@export var charge_up_duration: float = 0.5
@export var telegraph_animation: String = "idle"
@export var charge_animation: String = "walk"

@export_group("Collision Settings")
@export var stun_duration_on_hit: float = 0.7
@export var stun_animation: String = "idle"
# --- NOVAS VARIÁVEIS DE KNOCKBACK ---
@export var knockback_force: float = 600.0
@export var knockback_duration: float = 0.3 # Duração do knockback no player
# -------------------------------------

func execute(host: Boss, attack_component: AttackComponent) -> void:
	if not host.has_method("get_player_reference"):
		print("ERRO: O script do chefe precisa de uma referência ao player.")
		attack_component.finish_attack_manually()
		return
		
	var player = host.get_player_reference()
	if not is_instance_valid(player):
		print("ERRO: Referência do player é inválida.")
		attack_component.finish_attack_manually()
		return

	_start_charge_sequence(host, player, attack_component)

func _start_charge_sequence(host: Boss, player: Node2D, attack_component: AttackComponent) -> void:
	host.animation_component.handle_attack_animation(telegraph_animation, false)
	host.animation_component.face_target(host, player)

	await host.get_tree().create_timer(charge_up_duration).timeout

	var charge_direction = (player.global_position - host.global_position).normalized()
	
	attack_component.charge_direction = charge_direction
	attack_component.charge_speed = charge_speed
	attack_component.is_charging = true
	
	host.animation_component.handle_attack_animation(charge_animation, true)
