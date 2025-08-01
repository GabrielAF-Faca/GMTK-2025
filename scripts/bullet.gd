# bullet.gd
class_name Bullet
extends Node2D

# Exporta as variáveis para que possamos ajustá-las facilmente no Inspector
@export_group("Bullet Settings")
@export var armed_duration: float = 0.5   # Duração do estado "Ativada" (em segundos)
@export var cooldown_duration: float = 3.0 # Duração do estado "Desativada" (em segundos)

# Define os 3 estados possíveis da bullet usando um enum
enum Bullet_State { ARMABLE, ARMED, COOLDOWN }

# Guarda o estado atual da bullet
var current_state: Bullet_State = Bullet_State.ARMABLE

# Referências para os nós que vamos usar
@onready var sprite: Sprite2D = $Sprite2D
@onready var armed_timer: Timer = $ArmedTimer
@onready var cooldown_timer: Timer = $CooldownTimer
@onready var hitbox: Area2D = $Area2D

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
	change_state(Bullet_State.ARMABLE)
	
	# --- CORREÇÃO ---
	# Conecta o sinal de colisão da hitbox à função correta
	hitbox.area_entered.connect(_on_hitbox_area_entered)

# Função pública que o Player irá chamar para ativar a bullet
func activate():
	# Só podemos ativar se a bullet estiver no estado "Ativável"
	if current_state == Bullet_State.ARMABLE:
		change_state(Bullet_State.ARMED)

# Função central para mudar de estado
func change_state(new_state: Bullet_State):
	current_state = new_state
	
	match current_state:
		Bullet_State.ARMABLE:
			sprite.modulate = COLOR_ARMABLE
			hitbox.monitoring = false
			print("Bullet está ATIVÁVEL")
			
		Bullet_State.ARMED:
			sprite.modulate = COLOR_ARMED
			hitbox.monitoring = true
			armed_timer.start()
			print("Bullet foi ATIVADA!")
			
		Bullet_State.COOLDOWN:
			sprite.modulate = COLOR_COOLDOWN
			hitbox.monitoring = false
			cooldown_timer.start()
			print("Bullet em COOLDOWN")

# Chamado quando o tempo do estado "Ativada" acaba
func _on_armed_timer_timeout():
	change_state(Bullet_State.COOLDOWN)

# Chamado quando o tempo de "Cooldown" acaba
func _on_cooldown_timer_timeout():
	change_state(Bullet_State.ARMABLE)

# --- CORREÇÃO ---
# Função para quando a bullet atingir a Hurtbox do inimigo
func _on_hitbox_area_entered(area: Area2D):
	# A hitbox só está ativa no estado ARMED
	
	# Pega o nó pai da área atingida (o próprio Boss_Golem)
	var parent_body = area.get_parent()
	
	# Verifica se o corpo atingido tem um BossComponent
	if parent_body.has_node("BossComponent"):
		var boss_component = parent_body.get_node("BossComponent") as BossComponent
		# Chama a função no BossComponent para ele lidar com o dano
		boss_component.handle_bullet_hit()
