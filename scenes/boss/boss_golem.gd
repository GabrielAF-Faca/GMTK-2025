extends CharacterBody2D

# A variável 'life' foi removida. Agora é controlada pelo HealthComponent.
@export var speed: float = 100
@export var chase_range: float = 400.0
@export var attack_range: float = 60.0

@onready var boss_component: BossComponent = $BossComponent
@onready var animated_sprite: AnimatedSprite2D = $AnimatedSprite2D

func _ready():
	# Conecta o sinal 'died' do componente de vida a uma função neste script
	boss_component.health_component.died.connect(_on_died)

# Função chamada quando a vida do boss chega a zero
func _on_died():
	print("Boss Golem morreu!")
	# Aqui você pode desativar a colisão, tocar a animação de morte, etc.
	# Por exemplo, para tocar a animação de morte:
	animated_sprite.play("die")
	# Para impedir que ele se mova ou seja controlado pela state machine:
	set_physics_process(false)
