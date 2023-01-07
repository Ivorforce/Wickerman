extends Area2D
class_name PlayerAttackFX

export var damage := 1
export var time_left := 1.0
export var knockback := Vector2.ZERO
var source: Node2D = null

func _process(delta):	
	time_left -= delta
	if time_left <= 0:
		queue_free()

func _on_PlayerAttackFX_body_entered(body):
	var owner = body
	
	if owner is Corpse:
		owner._velocity += knockback
		owner.attackable.time_since_hit = 0
		Freezer.next_freeze_s += 0.01

	if owner is NPC:
		owner._velocity += knockback * 2
		owner.damage(1, source)
		owner.attackable.time_since_hit = 0
		Freezer.next_freeze_s += 0.03
