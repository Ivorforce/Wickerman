extends Node

onready var target: Vector2 = Vector2.ZERO

func _ready():
	target = get_parent().global_position

func _physics_process(delta):
	var parent: NPC = get_parent()
		
	var direction := target - parent.global_position

	if direction.length_squared() < 20 * 20:
		direction = Vector2.ZERO
		if randf() < 0.01:
			target = parent.global_position + Vector2(rand_range(-100, 100), rand_range(-100, 100))
			direction = target - parent.global_position

	if direction.length() > 1.0:
		direction = direction.normalized()

	var target_velocity = direction * parent.speed
	parent._velocity += (target_velocity - parent._velocity) * parent.friction
	parent._velocity = parent.move_and_slide(parent._velocity)
