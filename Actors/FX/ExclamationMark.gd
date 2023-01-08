extends Node2D
class_name ExclamationMark

var time_until_death := 0.2

func _process(delta):
	time_until_death -= delta
	if time_until_death <= 0:
		queue_free()
