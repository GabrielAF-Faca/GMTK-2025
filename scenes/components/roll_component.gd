class_name RollComponent
extends Node

@export_subgroup("Settings")
@export var dodge_speed: float = 120.0
@export var dodge_duration: float = 0.3

var dodge_roll_dir: Vector2 = Vector2.ZERO
var dodge_roll_timer: float = 0.0

var rolling = false

func handle_roll_movement(body: CharacterBody2D, delta: float) -> void:
	var elapsed_percent = 1.0 - (dodge_roll_timer/dodge_duration)
	var current_speed = lerp(dodge_speed, dodge_speed*0.5, elapsed_percent)
	
	body.velocity = dodge_roll_dir*current_speed
	
	dodge_roll_timer -= delta
	
	if dodge_roll_timer <= 0.0:
		dodge_roll_dir = Vector2.ZERO
		rolling = false

func _dodge_roll(direction: Vector2) -> void:
	if direction != Vector2.ZERO:
		dodge_roll_dir = direction
		dodge_roll_timer = dodge_duration
		rolling = true
