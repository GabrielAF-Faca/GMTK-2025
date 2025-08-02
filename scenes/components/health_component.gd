# HealthComponent.gd
class_name HealthComponent
extends Node

# --- Sinais ---
# Emitido quando a vida muda, para atualizar uma barra de vida, por exemplo.
signal health_changed(current_health: int)
# Emitido quando a vida chega a zero.
signal died
# Novo sinal emitido sempre que a entidade leva dano
signal damaged

# --- Propriedades ---
@export var max_health: int = 100
var current_health: int

func _ready():
	current_health = max_health

# Função pública para receber dano
func take_damage(damage_amount: int):

	current_health = max(0, current_health - damage_amount)
	emit_signal("health_changed", current_health)
	emit_signal("damaged") # Emite o sinal para notificar que levou dano
	print(owner.name, " tomou ", damage_amount, " de dano. Vida restante: ", current_health)

	if current_health == 0:
		emit_signal("died")
