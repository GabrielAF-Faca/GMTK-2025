extends Node

signal boss_attacking

var rng = RandomNumberGenerator.new()

func _ready() -> void:
	randomize()
