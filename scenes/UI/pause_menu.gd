extends CanvasLayer

signal change_scene_requested(scene_to_load: PackedScene)

@export var menu_scene: PackedScene

func _on_quit_button_pressed() -> void:
	get_tree().paused = false
	var torres = get_tree().get_nodes_in_group("Torres")
	if torres:
		for torre in torres:
			TowerManager.unregister_tower(torre)
	get_tree().change_scene_to_file("res://scenes/main.tscn")

func _on_resume_button_pressed() -> void:
	# Despausa o jogo
	get_tree().paused = false
	# Remove o menu de pause da árvore de cena
	queue_free()

func _unhandled_input(event: InputEvent):
	if event.is_action_pressed("ui_pause"):
		_on_resume_button_pressed()
		# Impede que o input seja processado por outros nós.
		get_viewport().set_input_as_handled()
