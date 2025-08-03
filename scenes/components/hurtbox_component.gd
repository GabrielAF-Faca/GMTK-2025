# hurtbox_component.gd
# Um componente que define uma área que pode receber dano.
class_name HurtboxComponent
extends Area2D

# Sinal emitido quando a vida muda. Útil para atualizar barras de vida na UI.
signal health_changed(current_health, max_health)
# Sinal emitido quando a vida chega a zero.
signal died


@export var max_health: float = 30.0
@export var hit_flash: AnimationPlayer


@onready var collision_shape: CollisionShape2D = $CollisionShape2D

var current_health: float

func _ready():
	# No início, a vida atual é igual à vida máxima.
	current_health = max_health
	
	# Garante que este nó processe colisões de área.
	set_deferred("monitoring", true)

# Esta é a função pública que outros nós (como um Hitbox) chamarão.
func take_damage(damage_amount: float):
	if current_health <= 0:
		return # Já está morto, não pode receber mais dano.
	
	var player_reference = get_tree().get_first_node_in_group("player")
	if owner == player_reference:
		player_reference.camera_component.screen_shake(2, 1)
	
	if hit_flash:
		hit_flash.play("hit")
	current_health -= damage_amount
	health_changed.emit(current_health, max_health)
	
	print("%s recebeu %s de dano. Vida restante: %s" % [owner.name, damage_amount, current_health])

	if current_health <= 0:
		
		died.emit()
		# Desativa a colisão para não receber mais dano após morrer.
		set_deferred("monitoring", false)

# Ativa o hitbox (geralmente no início de um frame de animação de ataque).
func activate():
	# Garante que a colisão esteja ativada no início do ataque.
	collision_shape.disabled = false

# Desativa o hitbox (geralmente no fim de um frame de animação de ataque).
func deactivate():
	# Desativa a colisão e para o timer para evitar que ele reative o hitbox
	# depois que o ataque já terminou.
	collision_shape.disabled = true
