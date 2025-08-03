class_name CameraComponent
extends Node

@export var camera_inicial: Camera2D
@export var camera_transicao: Camera2D
@export var camera_final: Camera2D

@export var player: CharacterBody2D

var camera: Camera2D

var shake_intensity: float = 0.0
var active_shake_time: float = 0.0

var shake_decay: float = 5.0

var shake_time: float = 0.0
var shake_time_speed: float = 20.0

var noise = FastNoiseLite.new()

func _physics_process (delta: float) -> void:
	if active_shake_time > 0:
		shake_time += delta * shake_time_speed
		active_shake_time -= delta
		
		camera.offset = Vector2(
			noise.get_noise_2d(shake_time, 0) * shake_intensity,
			noise.get_noise_2d(0, shake_time) * shake_intensity
		)
		
		shake_intensity = max(shake_intensity - shake_decay * delta, 0)
	else:
		camera.offset = lerp(camera.offset, Vector2.ZERO, 10.5 * delta)

func screen_shake(intensity: int, time: float):
	randomize()
	noise.seed = randi()
	noise.frequency = 2.0
	shake_intensity = intensity
	active_shake_time = time
	shake_time = 0.0

var transition_tween: Tween
var transition_zoom_tween: Tween
var transition_offset_tween: Tween

func _change_camera(desired_camera: Camera2D) -> void:
	if transition_tween:
		transition_tween.kill()
	
	transition_tween = create_tween()
	var target_transform: Transform2D = desired_camera.global_transform
	transition_tween.tween_property(camera_transicao, "global_transform", target_transform, 0.5)
	transition_tween.set_trans(Tween.TRANS_SINE)
	
	transition_zoom_tween = create_tween()
	var target_zoom: Vector2 = desired_camera.zoom
	transition_zoom_tween.tween_property(camera_transicao, "zoom", target_zoom, 0.5)
	transition_zoom_tween.set_trans(Tween.TRANS_SINE)
	
	transition_offset_tween = create_tween()
	var target_offset: Vector2 = desired_camera.offset
	transition_offset_tween.tween_property(camera_transicao, "offset", target_transform, 0.5)
	transition_offset_tween.set_trans(Tween.TRANS_SINE)
	
	camera_inicial = desired_camera
