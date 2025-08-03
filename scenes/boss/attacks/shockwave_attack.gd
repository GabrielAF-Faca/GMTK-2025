# ShockwaveAttack.gd
# Anexado à cena ShockwaveAttack.tscn
class_name ShockwaveAttack
extends BossAttack

# A cena da onda de choque que vamos instanciar.
@export var shockwave_scene: PackedScene
# A velocidade com que a onda de choque se expande.
@export var expansion_speed: float = 600.0
# A escala inicial da onda de choque.
@export var initial_scale: float = 0.1
# Quanto tempo a onda de choque permanece na tela antes de desaparecer.
@export var shockwave_lifetime: float = 2.0

# Sobrescreve a função execute para implementar a lógica do ataque.
func execute(host: Boss, attack_component: AttackComponent) -> void:
	# Retorna um erro se a cena da onda de choque não for definida no Inspetor.
	if not shockwave_scene:
		print("ERRO: A 'shockwave_scene' não foi definida no nó ShockwaveAttack.")
		return

	# Toca a animação de ataque definida na propriedade 'animation_name' do recurso.
	if animation_name and host.animation_component:
		host.animation_component.handle_attack_animation(animation_name, loop_animation)
	
	# Instancia a cena da onda de choque.
	var shockwave_instance = shockwave_scene.instantiate()
	
	# Adiciona a instância da onda de choque à cena principal.
	host.get_parent().add_child(shockwave_instance)
	
	# Inicia a onda de choque na posição do chefe com os parâmetros definidos.
	shockwave_instance.start(host.global_position, expansion_speed, initial_scale, shockwave_lifetime)
