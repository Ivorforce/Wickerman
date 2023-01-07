extends KinematicBody2D

# Movement speed in pixels per second.
export var speed := 350
export var speed_when_dragging := 200

export var corpse_drag_speed := 3000
export var corpse_drag_distance := 100

# A factor that controls the character's inertia.
export var friction = 0.18

# Mapping of direction to a sprite index.
var _sprites := {Vector2.RIGHT: 1, Vector2.LEFT: 2, Vector2.UP: 3, Vector2.DOWN: 4}
var _velocity := Vector2.ZERO

onready var animated_sprite: AnimatedSprite = $AnimatedSprite


var dragging_body: Corpse = null


func _input(ev):
	if ev is InputEventKey and ev.scancode == KEY_ENTER and not ev.is_echo() and ev.is_pressed():
		if dragging_body == null:
			var corpses := get_tree().get_nodes_in_group("corpses")
			if corpses.size() == 0:
				return
			
			var nearest: KinematicBody2D = corpses[0]
			for spawn_point in corpses:
				if spawn_point.global_position.distance_to(global_position) < nearest.global_position.distance_to(global_position):
					nearest = spawn_point
					
			dragging_body = nearest
			print(dragging_body)
		else:
			dragging_body = null

func drag_corpse() -> bool:
		var drag_direction := global_position - dragging_body.global_position
		
		if drag_direction.length() < corpse_drag_distance:
			return false
			
		if drag_direction.length() > 1:
			drag_direction = drag_direction.normalized()
		
		dragging_body._velocity += (drag_direction * corpse_drag_speed - dragging_body._velocity) * 0.05
		return true

func _physics_process(delta):
	var direction := Vector2(
		Input.get_action_strength("right") - Input.get_action_strength("left"),
		Input.get_action_strength("down") - Input.get_action_strength("up")
	)

	if direction.length() > 1.0:
		direction = direction.normalized()
		
	var target_velocity = direction * speed
	
	if dragging_body != null:
		if drag_corpse():
			target_velocity = direction * (speed_when_dragging * (0.7 + sin(OS.get_ticks_msec() / 100) * 0.3))

	_velocity += (target_velocity - _velocity) * friction
	_velocity = move_and_slide(_velocity)


# The code below updates the character's sprite to look in a specific direction.
func _unhandled_input(event):
	if event.is_action_pressed("right"):
		_update_sprite(Vector2.RIGHT)
	elif event.is_action_pressed("left"):
		_update_sprite(Vector2.LEFT)
	elif event.is_action_pressed("down"):
		_update_sprite(Vector2.DOWN)
	elif event.is_action_pressed("up"):
		_update_sprite(Vector2.UP)


func _update_sprite(direction: Vector2) -> void:
	animated_sprite.frame = _sprites[direction]
