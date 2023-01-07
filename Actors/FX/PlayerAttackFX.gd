extends Area2D
class_name FX

export var time_left := 1.0
export var knockback = Vector2.ZERO

func _process(delta):	
	time_left -= delta
	if time_left <= 0:
		queue_free()

func _on_PlayerAttackFX_area_entered(area):
	var owner = area.get_parent()
	
	if owner is Corpse:
		owner._velocity += knockback
	
	print("body entered")
