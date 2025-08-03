class_name State
extends Node


@export_group("State Time")
@export var state_time_min: float
@export var state_time_max: float

@onready var rng = RandomNumberGenerator.new()

var state_name: String = ""
var state_machine: StateMachine
var host: Boss

func _ready() -> void:
	host = owner

func enter_message():
	pass
	print(host.name, " entrando no estado "+state_name+".")

func exit_message():
	pass
	print(host.name, " saindo do estado "+state_name+".")

# Função chamada quando entramos neste estado.
func enter(): pass # Lógica de entrada (ex: iniciar animação, zerar um timer).

# Função chamada quando saímos deste estado.
func exit(): pass # Lógica de saída (ex: parar um som, limpar referências).

# Função para lógica de jogo que roda a cada frame.
func update(_delta: float): pass # Lógica do estado (ex: verificar distância do jogador).

# Função para lógica de física que roda em um loop fixo.
func physics_update(_delta: float): pass # Lógica de física (ex: aplicar movimento).
