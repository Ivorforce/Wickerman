extends KinematicBody2D

var PlayerAttackFXEntity := preload("res://Actors/FX/PlayerAttackFX.tscn")


# Movement speed in pixels per second.
export var speed := 350
export var speed_when_dragging := 200

export var corpse_drag_speed := 1000
export var corpse_drag_distance := 100

# A factor that controls the character's inertia.
export var friction = 0.18

var _time_to_attack := -1.0
var _recovery_time := -1.0

# Mapping of direction to a sprite index.
var _sprites := {Vector2.RIGHT: 1, Vector2.LEFT: 2, Vector2.UP: 3, Vector2.DOWN: 4}
var _look_direction := Vector2.RIGHT
var _look_direction_next := Vector2.RIGHT
var _velocity := Vector2.ZERO

onready var animated_sprite: AnimatedSprite = $AnimatedSprite


var dragging_body: Corpse = null


func handle_actions():
	if Input.is_action_just_pressed("action"):
		if dragging_body == null:
			var corpses := get_tree().get_nodes_in_group("corpses")
			if corpses.size() == 0:
				return
			
			var nearest: KinematicBody2D = corpses[0]
			for corpse in corpses:
				if corpse.global_position.distance_squared_to(global_position) < nearest.global_position.distance_squared_to(global_position):
					nearest = corpse
			
			if nearest.global_position.distance_to(global_position) < corpse_drag_distance:
				dragging_body = nearest
		else:
			dragging_body = null
			
	if Input.is_action_just_pressed("attack") and _time_to_attack <= 0 and dragging_body == null:
		_time_to_attack = 1		
	
	if Input.is_action_pressed("right"):
		_look_direction_next = Vector2.RIGHT
		_update_sprite()
	elif Input.is_action_pressed("left"):
		_look_direction_next = Vector2.LEFT
		_update_sprite()
	elif Input.is_action_pressed("down"):
		_look_direction_next = Vector2.DOWN
		_update_sprite()
	elif Input.is_action_pressed("up"):
		_look_direction_next = Vector2.UP
		_update_sprite()

func drag_corpse() -> bool:
		var drag_direction := global_position - dragging_body.global_position
		
		if drag_direction.length() < corpse_drag_distance:
			return false
			
		if drag_direction.length() > 1:
			drag_direction = drag_direction.normalized()
		
		dragging_body._velocity += (drag_direction * corpse_drag_speed - dragging_body._velocity) * 0.05
		return true

func _physics_process(delta):
	handle_actions()
	
	var direction := Vector2(
		Input.get_action_strength("right") - Input.get_action_strength("left"),
		Input.get_action_strength("down") - Input.get_action_strength("up")
	)

	if direction.length() > 1.0:
		direction = direction.normalized()
		
	var target_velocity = direction * speed
	
	if dragging_body != null:
		if drag_corpse():
			target_velocity = direction * (speed_when_dragging * (0.6 + sin(OS.get_ticks_msec() / 100) * 0.4))

	if _time_to_attack > 0:
		target_velocity *= _time_to_attack * 0.25

	if _recovery_time > 0:
		target_velocity *= 0.6 - _recovery_time * 3
		_recovery_time -= delta
		if _recovery_time <= 0:
			_update_sprite()

	_velocity += (target_velocity - _velocity) * friction
	_velocity = move_and_slide(_velocity)

	if _time_to_attack > 0:
		_time_to_attack -= delta
		if _time_to_attack <= 0:
			attack()

func attack():
	_recovery_time = 0.2
	
	var attack_fx: FX = PlayerAttackFXEntity.instance()
	attack_fx.time_left = 0.2
	attack_fx.knockback = _look_direction * 100
	get_parent().get_parent().get_parent().get_node("FX").add_child(attack_fx)
	attack_fx.global_position = global_position + _look_direction * 60


func _update_sprite() -> void:
	if _time_to_attack > 0 or _recovery_time > 0:
		# strafe
		return
	
	_look_direction = _look_direction_next
	animated_sprite.frame = _sprites[_look_direction]
