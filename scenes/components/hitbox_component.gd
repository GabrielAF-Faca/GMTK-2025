# hitbox_component.gd
# Um componente que define uma área que causa dano, com um cooldown após cada acerto.
class_name HitboxComponent
extends Area2D

@export var damage: float = 10.0
# O tempo em segundos que o hitbox fica desativado após acertar um alvo.
@export var hit_cooldown: float = 0.5
@export var source: CharacterBody2D

# Certifique-se de que este nó Timer exista como filho do HitboxComponent na cena.
@onready var cooldown_timer: Timer = $Timer
@onready var collision_shape: CollisionShape2D = $CollisionShape2D

func _ready():
	# Conecta os sinais necessários.
	area_entered.connect(_on_area_entered)
	cooldown_timer.timeout.connect(_on_cooldown_timer_timeout)

# Esta função é chamada automaticamente quando outra Area2D entra no Hitbox.
func _on_area_entered(area: Area2D):
	# Verificamos se a área que entrou é um Hurtbox.
	# A verificação 'collision_shape.disabled' previne que o sinal seja processado
	# se já tivermos acertado algo e estivermos no cooldown.
	if area.owner == source:
		return
	if area is HurtboxComponent and not collision_shape.disabled:
		# Chama a função 'take_damage' no Hurtbox.
		area.take_damage(damage)
		
		# Desativa a colisão imediatamente para não acertar de novo no mesmo frame.
		call_deferred("deactivate")
		# Inicia o timer de cooldown.
		cooldown_timer.start(hit_cooldown)

# Chamado quando o timer de cooldown termina.
func _on_cooldown_timer_timeout():
	# Reativa a colisão, permitindo que o hitbox acerte novamente.
	call_deferred("activate")

# Ativa o hitbox (geralmente no início de um frame de animação de ataque).
func activate():
	# Garante que a colisão esteja ativada no início do ataque.
	collision_shape.disabled = false

# Desativa o hitbox (geralmente no fim de um frame de animação de ataque).
func deactivate():
	# Desativa a colisão e para o timer para evitar que ele reative o hitbox
	# depois que o ataque já terminou.
	collision_shape.disabled = true
	#cooldown_timer.stop()
