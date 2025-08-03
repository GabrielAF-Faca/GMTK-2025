class_name HealthUI
extends Control

# Arraste as imagens dos corações aqui no Inspetor do Godot
@export var heart_full_texture: Texture2D
@export var heart_empty_texture: Texture2D

@onready var hearts_container: HBoxContainer = $HeartsContainer

# Chamado quando o jogo começa para garantir que a UI esteja correta.
func _ready():
	# Garante que todos os corações comecem cheios.
	# O número de corações é baseado em quantos TextureRects você adicionou.
	update_hearts(hearts_container.get_child_count())

# Esta é a função principal que atualiza os corações na tela.
# Em health_ui.gd
func update_hearts(current_health: int):
	# var actual_health = current_health/10  <-- REMOVA ESTA LINHA
	var all_hearts = hearts_container.get_children()

	for i in range(all_hearts.size()):
		var heart_node = all_hearts[i] as TextureRect
		if i < current_health: # <-- USE current_health DIRETAMENTE
			heart_node.texture = heart_full_texture
		else:
			heart_node.texture = heart_empty_texture
