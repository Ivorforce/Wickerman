extends KinematicBody2D
class_name Corpse

# A factor that controls the character's inertia.
export var friction = 0.18

# Mapping of direction to a sprite index.

var _velocity := Vector2.ZERO


func _physics_process(delta):	
	_velocity = move_and_slide(_velocity)
	_velocity = _velocity * friction
