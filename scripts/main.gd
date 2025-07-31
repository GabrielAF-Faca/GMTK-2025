extends Node


@export var menu_scene: PackedScene

# Referencia a cena que está atualmente na tela
var current_scene: Node

func _ready():
	change_scene(menu_scene)

func change_scene(scene_to_load: PackedScene):
	# Remove a cena atual se houver uma
	if is_instance_valid(current_scene):
		current_scene.queue_free()
	# Nova instância da cena que será carregada
	current_scene = scene_to_load.instantiate()
	# Conecta o sinal universal da nova cena a esta função
	if current_scene.has_signal("change_scene_requested"):
		# Qualquer cena pode alterar para a cena desejada
		current_scene.change_scene_requested.connect(change_scene)
	# Adiciona nova cena como filha do nó Main
	add_child(current_scene)

