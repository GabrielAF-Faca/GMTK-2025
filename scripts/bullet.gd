# bullet.gd
class_name Bullet
extends Node2D

# Exporta as variáveis para que possamos ajustá-las facilmente no Inspector
@export_group("Bullet Settings")
@export var armed_duration: float = 0.5   # Duração do estado "Ativada" (em segundos)
@export var cooldown_duration: float = 3.0 # Duração do estado "Desativada" (em segundos)
@export var hitbox_component: HitboxComponent
# Define os 3 estados possíveis da bullet usando um enum
enum Bullet_State { ARMABLE, ARMED, COOLDOWN, SPAWNING}

# Guarda o estado atual da bullet
var current_state: Bullet_State = Bullet_State.ARMABLE

# Referências para os nós que vamos usar
@onready var armed_timer: Timer = $ArmedTimer
@onready var cooldown_timer: Timer = $CooldownTimer
@onready var hitbox: Area2D = $Area2D
@onready var sprite: AnimatedSprite2D = $AnimatedSprite2D
@onready var explosion: AnimatedSprite2D = $Explosion


# Cores para dar feedback visual de cada estado
const COLOR_ARMABLE = Color.YELLOW
const COLOR_ARMED = Color.RED
const COLOR_COOLDOWN = Color.GRAY

func _ready():
	# Configura a duração dos timers com base nas variáveis exportadas
	armed_timer.wait_time = armed_duration
	cooldown_timer.wait_time = cooldown_duration
	
	# Conecta os sinais de timeout dos timers às suas funções
	armed_timer.timeout.connect(_on_armed_timer_timeout)
	cooldown_timer.timeout.connect(_on_cooldown_timer_timeout)
	
	# Inicia no estado "Ativável"
	change_state(Bullet_State.SPAWNING)
	

# Função pública que o Player irá chamar para ativar a bullet
func activate():
	# Só podemos ativar se a bullet estiver no estado "Ativável"
	if current_state == Bullet_State.ARMABLE:
		change_state(Bullet_State.ARMED)

# Função central para mudar de estado
func change_state(new_state: Bullet_State):
	current_state = new_state
	
	match current_state:
		Bullet_State.SPAWNING:
			sprite.play("cooldown")
			hitbox.monitoring = true
			armed_timer.start()
			sprite.scale = Vector2(5, 5)
		
		Bullet_State.ARMABLE:
			#sprite.modulate = COLOR_ARMABLE
			var tween = get_tree().create_tween()
			tween.tween_property(sprite, "scale", Vector2(10, 10), 0.1)
			tween.play()
			sprite.play("default")
			hitbox.monitoring = false
			hitbox_component.deactivate()
			print("Bullet está ATIVÁVEL")
		
		Bullet_State.ARMED:
			#sprite.modulate = COLOR_ARMED
			explosion.play("default")
			explosion.speed_scale = 1.0
			explosion.frame = 0
			explosion.scale = Vector2(0.5, 0.5)
			explosion.modulate = Color(1.0, 1.0, 1.0)
			hitbox_component.activate()
			
			var tween = get_tree().create_tween()
			tween.tween_property(explosion, "scale", Vector2(12, 11.7), 0.4)
			tween.set_parallel(true)
			tween.tween_property(explosion, "modulate", Color(1.0, 1.0, 1.0, 0.0), 1)
			tween.set_trans(Tween.TRANS_CUBIC)
			tween.set_ease(Tween.EASE_IN_OUT)
			tween.play()
			
			sprite.play("cooldown")
			
			var tween_scale = get_tree().create_tween()
			tween_scale.tween_property(sprite, "scale", Vector2(5, 5), 0.1)
			tween_scale.play()
			
			hitbox.monitoring = true
			armed_timer.start()
			print("Bullet foi ATIVADA!")
		
		Bullet_State.COOLDOWN:
			#sprite.modulate = COLOR_COOLDOWN
			hitbox.monitoring = false
			hitbox_component.deactivate()
			cooldown_timer.start()
			print("Bullet em COOLDOWN")

# Chamado quando o tempo do estado "Ativada" acaba
func _on_armed_timer_timeout():
	change_state(Bullet_State.COOLDOWN)

# Chamado quando o tempo de "Cooldown" acaba
func _on_cooldown_timer_timeout():
	change_state(Bullet_State.ARMABLE)
