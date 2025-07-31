extends CharacterBody2D

@export_subgroup("Components")
@export var input_component: InputComponent
@export var movement_component: MovementComponent
@export var animation_component: AnimationComponent
@export var roll_component: RollComponent

@onready var roll_timer: Timer = $RollTimer
var can_roll = true

func _physics_process(delta: float) -> void:
	
	if roll_component.rolling:
		roll_component.handle_roll_movement(self, delta)
	else:
		if input_component.roll and can_roll:
			can_roll = false
			roll_component._dodge_roll(input_component.direction)
			animation_component.handle_roll_animation(input_component.direction, roll_component.dodge_duration)
			roll_timer.start(roll_component.dodge_duration+0.1)
		else:
			movement_component.handle_movement(self, input_component.direction)
			animation_component.handle_move_animation(input_component.direction)

	move_and_slide()

func _on_roll_timer_timeout() -> void:
	can_roll = true
