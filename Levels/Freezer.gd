extends Node

var freeze_s := 0.0
var next_freeze_s := 0.0

func _physics_process(delta):
	if freeze_s > 0:
		get_tree().paused = true
		yield(get_tree().create_timer(min(freeze_s, 0.2)), 'timeout')
		get_tree().paused = false

	freeze_s = next_freeze_s
	next_freeze_s = 0
