# BossComponent.gd
class_name BossComponent
extends Node

# --- Propriedades ---
@export var damage_from_bullet: int = 60

# --- Referências ---
# O componente de vida será um filho deste nó
@onready var health_component: HealthComponent = $HealthComponent

# Função que será chamada pela bullet quando atingir o boss
func handle_bullet_hit():
	health_component.take_damage(damage_from_bullet)
