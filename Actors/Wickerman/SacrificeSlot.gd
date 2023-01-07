extends Area2D

export(NodePath) var _path_wickerman := @""
onready var wickerman: Wickerman = get_node(_path_wickerman)


func _process(delta):
	for body in get_overlapping_bodies():
		if body is Corpse and not body.is_protected:
			wickerman.try_sacrifice(body)
