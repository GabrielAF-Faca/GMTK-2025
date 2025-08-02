# boss_attack.gd
class_name BossAttack
extends Resource

@export var animation_name: String = "attack"

@export var attack_duration: float = 2.0

## Marque esta caixa se a animação deve repetir durante toda a 'attack_duration'.
## Desmarque para que a animação toque apenas uma vez.
@export var loop_animation: bool = false

@export var cooldown: float = 0.5


func execute(host: Boss, attack_component: AttackComponent) -> void:
	pass
