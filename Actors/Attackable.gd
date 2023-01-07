extends Node2D
class_name Attackable

var time_since_hit = 999

func _ready():
	material = material.duplicate()

func _physics_process(delta):	
	time_since_hit += delta
	material.set_shader_param("whitening", 0 if time_since_hit > 0.15 else 0.8)
