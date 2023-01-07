extends KinematicBody2D
class_name Corpse

export var friction = 0.8
var _velocity := Vector2.ZERO

onready var attackable: Attackable = $Sprite

func _physics_process(delta):	
	_velocity = move_and_slide(_velocity)
	_velocity = _velocity * friction
