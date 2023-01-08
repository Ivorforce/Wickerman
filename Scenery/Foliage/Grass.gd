extends Node2D
class_name Grass

func _ready():
	var _scale := rand_range(0.7, 1.3)
	scale = Vector2(_scale * rand_range(0.9, 1.1), _scale * rand_range(0.9, 1.1))
	
	var color := Vector3(rand_range(0.7, 1.0), rand_range(0.7, 1.0), rand_range(0.7, 1.0))

	$Sprite.material = $Sprite.material.duplicate()
	$Sprite.material.set_shader_param("color", color)
