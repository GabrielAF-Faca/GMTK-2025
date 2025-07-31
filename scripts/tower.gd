# Tower.gd
class_name Tower # <--- ESTA É A LINHA QUE FALTAVA
extends Area2D
# Este script é bem simples por enquanto.
# Ele serve apenas para identificar o nó como uma torre.
# No futuro, podemos adicionar vida, estados, etc.

func _ready():
	# Garante que a torre seja detectável por outras áreas e corpos.
	# Você pode ajustar as layers e masks de colisão no Inspector se necessário.
	pass
