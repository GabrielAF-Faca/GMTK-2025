# BossAttack.gd
# Classe base para todos os ataques do Boss, usando um Timer para controle de duração.
class_name BossAttack
extends Resource

# A duração do ataque em segundos. Controla por quanto tempo o Boss fica no estado de ataque.
@export var attack_duration: float = 1.0

# O nome da animação a ser tocada (opcional, mas recomendado para feedback visual).
@export var animation_name: String

# Se a animação deve ou não ficar em loop.
@export var loop_animation: bool = false

# A função execute é onde a lógica específica de cada ataque acontece.
func execute(host: Boss, attack_component: AttackComponent):
	# Garante que o componente de animação exista se um nome de animação for fornecido.
	if animation_name and not host.animation_component:
		print("AVISO: AnimationComponent não encontrado no host '%s' para tocar a animação '%s'." % [host.name, animation_name])
		return
