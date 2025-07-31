class_name MovementComponent
extends Node

@export_group("Settings")
@export var speed: float = 100
@export var accel_speed: float = 6.0
@export var decel_speed: float = 8.0



func handle_movement(body: CharacterBody2D, direction: Vector2) -> void:
	
	var velocity_change_speed: float = accel_speed if direction != Vector2.ZERO else decel_speed
	
	body.velocity = body.velocity.move_toward(direction*speed, velocity_change_speed)
