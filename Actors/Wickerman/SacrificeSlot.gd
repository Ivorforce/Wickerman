extends Area2D

export(NodePath) var _path_wickerman := @""
onready var wickerman: Wickerman = get_node(_path_wickerman)

onready var level: Level1 = $".."

func _process(delta):
	for body in get_overlapping_bodies():
		if body is Corpse and not body.is_protected:
			wickerman.try_sacrifice(body)
			
		if body is PlayerController and body.dragging_body == null and level.time_of_day > 0.9:
			body.change_to_torch()
