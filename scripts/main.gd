extends Node

@export var game_scene: PackedScene

func _ready():
	get_tree().change_scene_to_file("res://scenes/game.tscn")
