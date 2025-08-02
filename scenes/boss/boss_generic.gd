class_name Boss
extends CharacterBody2D

@export_subgroup("Components")
@export var health_component: HealthComponent
@export var movement_component: MovementComponent
@export var animation_component: AnimationComponent

@export_subgroup("State Machine")
@export var state_machine: StateMachine

@export_subgroup("Settings")
@export var damage_from_bullet: int = 60
@export var standing_points: Node2D

var move_direction = Vector2.ZERO

# Função que será chamada pela bullet quando atingir o boss
func handle_bullet_hit():
	health_component.take_damage(damage_from_bullet)

func _physics_process(delta: float) -> void:
	movement_component.handle_movement(self, move_direction)
	animation_component.handle_move_animation(move_direction)
	
	move_and_slide()
