# tower.gd
class_name Tower
extends Area2D

var original_scale: Vector2
@onready var point: Marker2D = $Marker2D


func _ready():
	# Guarda a escala original da torre definida no editor
	original_scale = self.scale
	set_y_sort_enabled(true)

# Nova função para a animação de "spawn"
func play_spawn_animation():
	# Começa com a escala em zero para o efeito "pop"
	scale = Vector2.ZERO
	
	# Cria um tween para a animação
	var tween = create_tween()
	# Define a transição para ser mais elástica (cria um efeito de "bounce")
	tween.set_trans(Tween.TRANS_ELASTIC)
	tween.set_ease(Tween.EASE_OUT)
	
	# Anima a propriedade "scale" de volta para a sua escala original
	# A animação durará 0.6 segundos. Pode ajustar este valor.
	tween.tween_property(self, "scale", original_scale, 0.6)
