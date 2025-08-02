# simple_melee_attack.gd
class_name SimpleMeleeAttack
extends BossAttack

# Podemos pré-configurar os valores no _init ou alterá-los no inspetor.
func _init():
	animation_name = "attack"
	attack_duration = 2.6 # O mesmo tempo do seu Timer original.

func execute(host: Boss, attack_component: AttackComponent):
	# Garante que o host tenha o componente de animação.
	if not host.animation_component:
		print("ERRO: SimpleMeleeAttack não encontrou o AnimationComponent no host.")
		return
		
	# --- LINHA CORRIGIDA ---
	# Manda o componente de animação do chefe tocar a animação correta,
	# usando as propriedades definidas neste recurso (animation_name e loop_animation).
	host.animation_component.handle_attack_animation(animation_name, loop_animation)
