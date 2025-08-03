extends Control

@export var back_button: Button

func _ready():
	if back_button:
		back_button.grab_focus()

func _on_back_pressed() -> void:
	get_tree().change_scene_to_file("res://scenes/main.tscn")
