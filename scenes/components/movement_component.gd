class_name MovementComponent
extends Node

@export_group("Settings")
@export var speed: float = 100
@export var accel_speed: float = 6.0
@export var decel_speed: float = 8.0
@export var knockback_friction: float = 25.0 # Atrito a ser aplicado durante o knockback

# --- NÓS ---
# Certifique-se de que este Timer foi adicionado como filho na cena do componente.
@onready var knockback_timer: Timer = $KnockbackTimer

# --- ESTADO ---
var is_knocked_back: bool = false

func _ready():
	knockback_timer.timeout.connect(_on_knockback_timer_timeout)

func handle_movement(body: CharacterBody2D, direction: Vector2) -> void:
	# Se estiver em knockback, o movimento normal é ignorado e o atrito é aplicado.
	if is_knocked_back:
		body.velocity = body.velocity.move_toward(Vector2.ZERO, knockback_friction)
		return

	# Lógica de movimento padrão.
	var velocity_change_speed: float = accel_speed if direction != Vector2.ZERO else decel_speed
	body.velocity = body.velocity.move_toward(direction * speed, velocity_change_speed)

# Nova função para aplicar o knockback diretamente a partir deste componente.
func apply_knockback(body: CharacterBody2D, direction: Vector2, force: float, duration: float):
	# Impede que um novo knockback comece se um já estiver ativo.
	if is_knocked_back:
		return

	is_knocked_back = true
	body.velocity = direction * force
	knockback_timer.wait_time = duration
	knockback_timer.start()

# Chamado quando o timer de knockback termina.
func _on_knockback_timer_timeout():
	is_knocked_back = false
