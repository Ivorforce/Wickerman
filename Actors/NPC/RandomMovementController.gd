extends Node

onready var target: Vector2 = Vector2.ZERO
var time_since_reorientation := 0.0
var is_running = false

func _ready():
	target = get_parent().global_position

func _physics_process(delta: float):
	var parent: NPC = get_parent()
	
	time_since_reorientation += delta
	
	var direction := target - parent.global_position
	var speed = parent.speed
	
	if parent.is_shocked_time >= 0:
		speed = 0
	elif parent.health < parent.max_health:
		speed *= sqrt(float(parent.health) / parent.max_health)
	
	if parent.is_scared_target != null:
		var difference := parent.is_scared_target.global_position - parent.global_position
		var dist_mul := 1.3 if is_running else 1.0
		
		if difference.length_squared() < parent.sight_distance * parent.sight_distance * dist_mul * dist_mul:
			direction = -difference
			speed *= 1.2
			is_running = true
		else:
			target = parent.global_position
			time_since_reorientation = 0.0
			direction = Vector2.ZERO
			is_running = false

	if (time_since_reorientation > 0.1) if direction.length_squared() < 20 * 20 else (time_since_reorientation > 2):
		direction = Vector2.ZERO
		if randf() < 0.02:
			direction = find_new_target()

	if direction.length() > 1.0:
		direction = direction.normalized()

	var target_velocity = direction * speed
	parent._velocity += (target_velocity - parent._velocity) * parent.friction
	parent._velocity = parent.move_and_slide(parent._velocity)


func find_new_target() -> Vector2:
	var parent: NPC = get_parent()
	
	# boids-like algorithm
	var too_close_n := 0
	var too_close_v := Vector2.ZERO
	
	var in_range_n := 1
	var in_range_v := parent.global_position
	
	for entity in get_tree().get_nodes_in_group(parent.group):
		if entity == parent:
			continue
	
		var distance_sq: float = entity.global_position.distance_squared_to(parent.global_position)
		
		if distance_sq < parent.personal_space_distance * parent.personal_space_distance:
			too_close_v += entity.global_position
			too_close_n += 1
		elif distance_sq < parent.huddle_distance * parent.huddle_distance:
			in_range_v += entity.global_position
			in_range_n += 1

	
	target = in_range_v / in_range_n + Vector2(rand_range(-100, 100), rand_range(-100, 100))
	
	if too_close_n > 0 or false:
		# Remove any movement toward stuff that is too close
		var vector := target - parent.global_position 
		vector -= (too_close_v / too_close_n - parent.global_position) * 3
		target = vector + parent.global_position
	
	time_since_reorientation = 0.0
	return target - parent.global_position
