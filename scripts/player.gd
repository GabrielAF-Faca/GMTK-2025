extends CharacterBody2D

@export_subgroup("Components")
@export var input_component: InputComponent
@export var movement_component: MovementComponent
@export var animation_component: AnimationComponent

func _physics_process(delta: float) -> void:
	movement_component.handle_movement(self, input_component.direction, delta)
	
	#animation_component.handle_move_animation(input_component.direction)
	move_and_slide()
