class_name MovementComponent
extends Node

@export_group("Settings")
@export var speed: float = 100

func handle_movement(body: CharacterBody2D, direction: Vector2) -> void:
	body.velocity = direction * speed
