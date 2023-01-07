extends Node

onready var target: Vector2 = Vector2.ZERO
var is_running = false

func _ready():
	target = get_parent().global_position

func _physics_process(delta):
	var parent: NPC = get_parent()
	
	var direction := target - parent.global_position
	var speed = parent.speed
		
	if parent.is_scared_target != null:
		var difference := parent.is_scared_target.global_position - parent.global_position
		var dist_mul := 1.3 if is_running else 1.0
		
		if difference.length_squared() < parent.sight_distance * parent.sight_distance * dist_mul * dist_mul:
			direction = -difference
			speed *= 1.2
			is_running = true
		else:
			target = parent.global_position
			direction = Vector2.ZERO
			is_running = false

	if direction.length_squared() < 20 * 20:
		direction = Vector2.ZERO
		if randf() < 0.01:
			target = parent.global_position + Vector2(rand_range(-100, 100), rand_range(-100, 100))
			direction = target - parent.global_position

	if direction.length() > 1.0:
		direction = direction.normalized()

	var target_velocity = direction * speed
	parent._velocity += (target_velocity - parent._velocity) * parent.friction
	parent._velocity = parent.move_and_slide(parent._velocity)

