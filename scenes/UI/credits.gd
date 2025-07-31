extends Control

signal change_scene_requested(scene_to_load: PackedScene)

@export var menu_scene: PackedScene

func _on_back_pressed() -> void:
	change_scene_requested.emit(menu_scene)
