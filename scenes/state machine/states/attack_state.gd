class_name AttackState
extends State

func _ready() -> void:
	state_name = "attack"

var attack = true

func enter():
	enter_message()
	#host.get_node("AnimatedSprite2D").play("idle")

func exit():
	attack = true
	exit_message()

func update(delta: float):
	if attack:
		attack = false
		Global.boss_attacking.emit()
		return
		
	if not host.attack_component.attacking:
		state_machine.change_state()

		
