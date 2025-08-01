# ActivateBulletComponent.gd
class_name ActivateBulletComponent
extends Node

@onready var input_component: InputComponent = owner.get_node("InputComponent")

func _process(_delta):
	# Verifica se a ação de ativar a bullet foi pressionada
	if input_component.activate_bullet:
		# Chama a função no TowerManager para ele se encarregar de ativar a bullet
		TowerManager.activate_bullet()
