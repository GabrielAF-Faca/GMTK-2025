extends Node

var pause_menu_scene = preload("res://scenes/UI/pause_menu.tscn")

# Esta função será chamada a cada frame
func _unhandled_input(event: InputEvent):
	# A ação padrão para a tecla Esc é "ui_cancel".
	# Vamos verificar se a tecla está sendo detectada.
	if event.is_action_pressed("ui_pause"):
		# Verificação se existe algum nó no grupo "gameplay".
		var gameplay_nodes = get_tree().get_nodes_in_group("gameplay")		
		if gameplay_nodes.is_empty():
			return
		if not get_tree().paused:
			get_tree().paused = true
			var pause_menu_instance = pause_menu_scene.instantiate()
			get_tree().current_scene.add_child(pause_menu_instance)
