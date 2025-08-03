# attack_state.gd
class_name AttackState
extends State

func _ready() -> void:
	state_name = "attack"

# Lógica de entrada no estado de ataque.
func enter():
	#enter_message()
	
	if not host.has_node("AttackComponent"):
		print("ERRO: AttackComponent não encontrado no host!")
		state_machine.change_state()
		return
		
	var attack_component = host.attack_component

	if not attack_component.attacking:
		if not attack_component.attack_finished.is_connected(_on_attack_finished):
			attack_component.attack_finished.connect(_on_attack_finished)
		attack_component.perform_attack()
	else:
		state_machine.change_state()

# Lógica de saída do estado.
func exit():
	#exit_message()
	# Desliga a flag de charge para garantir que o chefe pare de se mover.
	host.attack_component.is_charging = false
	#host.is_stunned = false
	#var attack_component = host.get_node("AttackComponent")
	#if attack_component.attack_finished.is_connected(_on_attack_finished):
		#attack_component.attack_finished.disconnect(_on_attack_finished)

## Esta função é chamada quando o AttackComponent emite o sinal 'attack_finished'.
func _on_attack_finished():
	print("Attack finished callback triggered")
	# Agora que o ataque terminou, podemos mudar para um estado aleatório.
	state_machine.change_state()


# A função update não é mais necessária aqui, a lógica agora é orientada a eventos!
func update(delta: float):
	pass
