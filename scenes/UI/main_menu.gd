extends Control

signal change_scene_requested(scene_to_load: PackedScene)

@export var start_button: Button
@export var game_scene: PackedScene
@export var credits_scene: PackedScene
@export var controls_scene: PackedScene

func _ready():
	if start_button:
		start_button.grab_focus()

func _on_start_pressed() -> void:
	change_scene_requested.emit(game_scene)

func _on_controls_pressed() -> void:
	change_scene_requested.emit(controls_scene)

func _on_credits_pressed() -> void:
	change_scene_requested.emit(credits_scene)
