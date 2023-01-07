extends KinematicBody2D
class_name Corpse

export var vegetable_type := 0
var is_protected := false

export var friction := 0.8
var _velocity := Vector2.ZERO

onready var attackable: Attackable = $Sprite

func _physics_process(delta):	
	_velocity = move_and_slide(_velocity)
	_velocity = _velocity * friction
