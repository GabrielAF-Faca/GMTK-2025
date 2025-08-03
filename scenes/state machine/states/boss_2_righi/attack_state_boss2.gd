# AttackStateBoss2.gd
class_name AttackStateBoss2
extends State

@export_group("Ranges")
@export var melee_range: float = 80.0       # A distância máxima para usar o ataque melee
@export var dash_min_range: float = 200.0   # A distância mínima para usar o dash

func _ready() -> void:
	state_name = "attack"

func enter():
	# Para o movimento normal assim que entra no estado de ataque.
	host.move_direction = Vector2.ZERO
	
	if not host.attack_component:
		state_machine.change_state("idle")
		return
		
	# Conecta o sinal de fim de ataque para saber quando voltar ao estado Idle.
	if not host.attack_component.attack_finished.is_connected(_on_attack_finished):
		host.attack_component.attack_finished.connect(_on_attack_finished)
	
	# Decide e executa o ataque.
	choose_attack()

# Esta função agora controla o movimento do boss DURANTE um ataque.
# Para funcionar, a linha 'current_state.physics_update(delta)'
# deve estar ativa no _physics_process do seu StateMachine.
func physics_update(_delta: float):
	if not host or not host.attack_component:
		return

	if host.attack_component.is_charging:
		# Se estiver no meio de um dash, aplica a velocidade de charge.
		host.velocity = host.attack_component.charge_direction * host.attack_component.charge_speed
	else:
		# Para ataques melee ou na preparação do dash, o boss fica parado.
		host.velocity = Vector2.ZERO

func choose_attack():
	var player = host.get_player_reference()
	if not is_instance_valid(player):
		state_machine.change_state("idle")
		return

	var distance_to_player = host.global_position.distance_to(player.global_position)
	
	if distance_to_player < melee_range:
		host.attack_component.perform_attack_by_type("SimpleMeleeAttack")
	elif distance_to_player > dash_min_range:
		host.attack_component.perform_attack_by_type("DashAttack")
	else:
		# Como padrão, usa o ataque melee se estiver em distância intermediária.
		host.attack_component.perform_attack_by_type("SimpleMeleeAttack")

func _on_attack_finished():
	state_machine.change_state("idle")

func exit():
	# Garante que o sinal seja desconectado para evitar chamadas múltiplas.
	if is_instance_valid(host) and host.attack_component and host.attack_component.attack_finished.is_connected(_on_attack_finished):
		host.attack_component.attack_finished.disconnect(_on_attack_finished)
