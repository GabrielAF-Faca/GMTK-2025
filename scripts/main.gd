extends Node

@export_subgroup("Scenes")
@export var game_scene: PackedScene

func _ready() -> void:
	change_scene(game_scene)

func change_scene(scene: PackedScene):
	get_tree().change_scene_to_packed(scene)
