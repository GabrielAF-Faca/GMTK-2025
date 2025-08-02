# attack_component.gd
class_name AttackComponent
extends Node

signal attack_finished

@export var attacks: Array[BossAttack]

@onready var attack_timer: Timer = $AttackTimer
@onready var host = owner

var can_attack: bool = true
var attacking: bool = false
var current_attack: BossAttack

func _ready():
	if not attack_timer.timeout.is_connected(_on_attack_timer_timeout):
		attack_timer.timeout.connect(_on_attack_timer_timeout)


func perform_attack():
	if attacking or attacks.is_empty():
		return
	
	if not can_attack:
		return
	
	can_attack = false

	attacking = true
	current_attack = attacks.pick_random()
	
	attack_timer.wait_time = current_attack.attack_duration
	attack_timer.start()
	
	current_attack.execute(host, self)


func _on_attack_timer_timeout():
	attacking = false
	can_attack = true
	attack_finished.emit()
