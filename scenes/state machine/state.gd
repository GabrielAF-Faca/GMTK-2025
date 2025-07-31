class_name State
extends Node

var state_machine: Node
var host: Node

func _ready() -> void:
	# Espera o nó estar pronto na árvore de cena para garantir que o owner exista.
	await owner.ready
	host = owner

# Função chamada quando entramos neste estado.
func enter():
	pass # Lógica de entrada (ex: iniciar animação, zerar um timer).

# Função chamada quando saímos deste estado.
func exit():
	pass # Lógica de saída (ex: parar um som, limpar referências).

# Função para lógica de jogo que roda a cada frame.
func update(_delta: float):
	pass # Lógica do estado (ex: verificar distância do jogador).

# Função para lógica de física que roda em um loop fixo.
func physics_update(_delta: float):
	pass # Lógica de física (ex: aplicar movimento).
