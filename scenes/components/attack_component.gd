# attack_component.gd
class_name AttackComponent
extends Node

signal attack_finished

@export var attacks: Dictionary[String, BossAttack]

@onready var attack_timer: Timer = $AttackTimer
@onready var host: Boss = owner

var attacking: bool = false
var current_attack: BossAttack

var is_charging: bool = false
var charge_direction: Vector2 = Vector2.ZERO
var charge_speed: float = 0.0

func _ready():
	if attacks.is_empty():
		print("AVISO DE DEPURACAO: O array 'attacks' do AttackComponent está vazio.")
	attack_timer.timeout.connect(_on_attack_timer_timeout)

func perform_attack(attack_name:String=""):
	if attacking or attacks.is_empty(): return
	
	
	if not attack_name.length():
		current_attack = attacks.values().pick_random()
	else:
		current_attack = attacks[attack_name]
		
	attacking = true
	
	if not current_attack:
		print("ERRO: Tentativa de realizar um ataque nulo.")
		attacking = false
		return
		
	attack_timer.wait_time = current_attack.attack_duration
	attack_timer.start()
	current_attack.execute(host, self)

# --- FUNÇÃO MODIFICADA ---
func handle_charge_attack(_delta: float):
	if not is_charging:
		host.movement_component.handle_movement(host, Vector2.ZERO)
		return

	host.animation_component.add_ghost(host, charge_direction)
	host.velocity = charge_direction * charge_speed
	host.set_collision_mask_value(9, true)
	
	var collision = host.get_last_slide_collision()
	if collision:
		var collider = collision.get_collider()
		
		# Verifica se colidiu com o player.
		if collider and collider.is_in_group("player"):
			
			var charge_attack = current_attack as ChargeAttack
			if charge_attack and collider.movement_component.has_method("apply_knockback"):
				# Aplica a força de knockback no player.
				collider.movement_component.apply_knockback(collider, charge_direction, charge_attack.knockback_force, charge_attack.knockback_duration)
				host.audio_component.play_audio_stream("batendo_chao")
				# Opcional: Fazer o chefe parar ou ficar atordoado ao acertar o player.
				# Se quiser que o chefe pare a investida ao acertar, descomente as linhas abaixo.
				is_charging = false
				host.set_collision_mask_value(9, false)
				#finish_attack_manually()

		# Se colidiu com qualquer outra coisa (parede) e não está atordoado...
		elif host.stun_timer.is_stopped():
			is_charging = false
			host.audio_component.play_audio_stream("batendo_chao")
			host.player.camera_component.screen_shake(10, 0.8)
			host.set_collision_mask_value(9, false)
			stop_attack_timer()
			
			var charge_attack = current_attack as ChargeAttack
			if charge_attack:
				host.stun_timer.wait_time = charge_attack.stun_duration_on_hit
				host.animation_component.handle_attack_animation(charge_attack.stun_animation, false)

			host.stun_timer.start()

func _on_attack_timer_timeout():
	if attacking:
		attacking = false
		is_charging = false
		attack_finished.emit()

func finish_attack_manually():
	if not attacking: return
	attack_timer.stop()
	_on_attack_timer_timeout()

func stop_attack_timer():
	attack_timer.stop()
