extends KinematicBody2D
class_name Corpse

# A factor that controls the character's inertia.
export var friction = 0.8

onready var sprite = $Sprite

# Mapping of direction to a sprite index.

var _velocity := Vector2.ZERO
var time_since_hit = 999

func _physics_process(delta):	
	_velocity = move_and_slide(_velocity)
	_velocity = _velocity * friction
	
	time_since_hit += delta
	sprite.material.set_shader_param("whitening", 0 if time_since_hit > 0.15 else 0.8)
