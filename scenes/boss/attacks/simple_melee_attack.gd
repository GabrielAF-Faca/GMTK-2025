# simple_melee_attack.gd
class_name SimpleMeleeAttack
extends BossAttack

# Pré-configuramos os valores no _init. Eles podem ser alterados no Inspetor
# para cada recurso de ataque que você criar.
func _init():
	# Define a duração padrão deste ataque. Este é o valor que o Timer usará.
	attack_duration = 1.5
	# Define a animação a ser tocada.
	animation_name = "attack"
	loop_animation = false

func execute(host: Boss, attack_component: AttackComponent):
	# Chama a função base primeiro para as verificações.
	super.execute(host, attack_component)
	
	# Se tivermos um componente de animação e um nome de animação, tocamos a animação.
	# A lógica do jogo NÃO vai esperar a animação terminar. Ela vai esperar o Timer.
	if host.animation_component and animation_name:
		host.animation_component.handle_attack_animation(animation_name, loop_animation)
