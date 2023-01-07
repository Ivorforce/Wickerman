extends KinematicBody2D
class_name FX

export var time_left := 1.0

func _process(delta):	
	time_left -= delta
	if time_left <= 0:
		queue_free()
