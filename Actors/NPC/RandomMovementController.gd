extends KinematicBody2D

# Movement speed in pixels per second.
export var speed := 500
# A factor that controls the character's inertia.
export var friction = 0.18

# Mapping of direction to a sprite index.

var _velocity := Vector2.ZERO


func _physics_process(delta):
	var direction := Vector2(0, 0)
	# When aiming the joystick diagonally, the direction vector can have a length 
	# greater than 1.0, making the character move faster than our maximum expected
	# speed. When that happens, we limit the vector's length to ensure the player 
	# can't go beyond the maximum speed.
	if direction.length() > 1.0:
		direction = direction.normalized()
	# Using the follow steering behavior.
	var target_velocity = direction * speed
	_velocity += (target_velocity - _velocity) * friction
	_velocity = move_and_slide(_velocity)
