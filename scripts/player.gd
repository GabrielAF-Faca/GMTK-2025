extends CharacterBody2D

@export_subgroup("Components")
@export var input_component: InputComponent
@export var movement_component: MovementComponent
@export var animation_component: AnimationComponent
@export var roll_component: RollComponent


func _physics_process(delta: float) -> void:
	
	if not roll_component.rolling:
		movement_component.handle_movement(self, input_component.direction, delta)
	else:
		roll_component.handle_roll_movement(self, input_component.direction, delta)
	
	if input_component.roll:
		roll_component._dodge_roll(input_component.direction)
		animation_component.handle_roll_animation(input_component.direction, roll_component.dodge_duration)

	#animation_component.handle_move_animation(input_component.direction)
	move_and_slide()
