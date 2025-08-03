class_name Shockwave
extends Area2D

var expansion_speed: float = 500.0

# Função para iniciar a onda de choque
func start(pos: Vector2, speed: float, start_scale: float, duration: float):
	global_position = pos
	expansion_speed = speed
	scale = Vector2.ONE * start_scale

	# Usa um timer para se autodestruir após a duração
	var lifetime_timer = get_tree().create_timer(duration)
	await lifetime_timer.timeout
	queue_free()

func _process(delta: float):
	# Aumenta a escala do anel a cada frame
	scale += Vector2.ONE * (expansion_speed / 100.0) * delta
