extends Control

signal change_scene_requested(scene_to_load: PackedScene)

@export var game_scene: PackedScene

func _on_start_pressed() -> void:
	change_scene_requested.emit(game_scene)

func _on_credits_pressed() -> void:
	pass # change_scene_requested.emit(credits_scene)
