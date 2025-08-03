# activator_shot.gd
class_name ActivatorShot
extends Area2D

# Velocidade do projétil. Pode ajustar no Inspector.
@export var speed: float = 800.0
@export var audio_component: AudioComponent

@onready var animated_sprite_2d: AnimatedSprite2D = $AnimatedSprite2D
@onready var timer: Timer = $Timer


# O alvo que este projétil irá perseguir (a Bullet principal)
var target: Node2D = null

var destruiu = false

func _ready():
	# Conecta os sinais de colisão e visibilidade
	area_entered.connect(_on_area_entered)
	body_entered.connect(_on_body_entered)
	$VisibleOnScreenNotifier2D.screen_exited.connect(queue_free)

func _process(delta: float):
	
	if destruiu:
		return
	
	# Se o alvo não for válido (ainda não foi definido ou foi destruído), o projétil se destrói.
	if not is_instance_valid(target):
		queue_free()
		return

	# A cada frame, recalcula a direção para o alvo
	var direction = (target.global_position - global_position).normalized()
	
	animated_sprite_2d.rotation = get_angle_to(target.global_position)
	# Move o projétil na nova direção
	global_position += direction * speed * delta

# Chamado quando colide com outra Area2D
func _on_area_entered(area: Area2D):
	# Verifica se a área com que colidiu pertence ao nosso alvo
	if area.get_parent() == target:
		# Se for a Bullet, chama a função para ativá-la
		TowerManager.activate_bullet()
		# E destrói-se a si mesmo
		queue_free()
		

# Chamado quando colide com um PhysicsBody2D (paredes, obstáculos)
func _on_body_entered(_body: Node2D):
	# Se colidir com qualquer corpo físico, destrói-se.
	#owner.audio_component.play_audio_stream("pode_atirar")
	audio_component.play_audio_stream("destroy", Vector2(0.9, 1.1))
	
	destruiu = true
	$AnimatedSprite2D.visible = false
	timer.start()


func _on_timer_timeout() -> void:
	queue_free()
