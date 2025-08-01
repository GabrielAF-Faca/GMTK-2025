class_name Mov_CycleState
extends State

# A velocidade de movimento do chefe.
@export var linear_velocity: int = 100
# O raio do círculo que o chefe irá percorrer.
@export var radius: float = 150.0
# A velocidade com que ele gira em torno do círculo (em radianos por segundo).
@export var angular_speed: float = 1.0
# A duração total em segundos que ele ficará neste estado.
@export var cycle_duration: float = 10.0
# O nome do próximo estado para o qual ele deve transicionar.
@export var next_state_name: String = "Chase"

var center_point: Vector2
var current_angle: float = 0.0
var timer: float

# Chamado uma vez quando o estado é ativado.
func enter():
	print(host.name, " entrando no estado Mov_Cycle.")
	# Define o centro do círculo como a posição onde o chefe estava
	# no momento em que entrou neste estado.
	center_point = host.global_position
	# Reseta o ângulo e o timer.
	current_angle = 0.0
	timer = cycle_duration
	# Toca a animação de andar, se existir.
	if host.has_node("AnimatedSprite2D"):
		host.get_node("AnimatedSprite2D").play("walk")

# Chamado uma vez quando o estado é desativado.
func exit():
	print(host.name, " saindo do estado Mov_Cycle.")
	# Opcional: Para o movimento bruscamente ao sair do estado.
	host.velocity = Vector2.ZERO

# Lógica que roda a cada frame (ideal para timers e checagens não relacionadas à física).
func update(delta: float):
	# O timer para decidir quando trocar de estado roda aqui.
	timer -= delta
	if timer <= 0:
		state_machine.change_state(next_state_name)

# Lógica que roda em um loop de física fixo (ideal para movimento e colisões).
func physics_update(delta: float):
	# 1. Atualiza o ângulo para girar em torno do ponto central.
	current_angle += angular_speed * delta

	# 2. Calcula a próxima posição-alvo no perímetro do círculo.
	var offset = Vector2(cos(current_angle), sin(current_angle)) * radius
	var target_position = center_point + offset

	# 3. Calcula a direção do movimento.
	# O chefe se move da sua posição atual em direção ao próximo ponto no círculo.
	var direction = host.global_position.direction_to(target_position)

	# 4. Define a velocidade e move o chefe usando a física do Godot.
	host.velocity = direction * linear_velocity
	host.move_and_slide()
