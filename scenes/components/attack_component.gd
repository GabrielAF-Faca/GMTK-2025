class_name AttackComponent
extends Node

@onready var attack_timer: Timer = $AttackTimer

var attacking = false

func _ready():
	attack_timer.timeout.connect(_on_attack_timer_timeout)


func attack():
	attacking = true
	if attack_timer.is_stopped():
		attack_timer.start()


func _on_attack_timer_timeout():
	attacking = false
