extends KinematicBody2D
class_name Corpse

export var vegetable_type := 0
var is_protected := false
export var blood_scale := 1.0

export var friction := 0.8
var _velocity := Vector2.ZERO
var next_bleed_distance_sq: float

onready var attackable: Attackable = $Sprite

onready var BloodEntity = preload("res://Scenery/Blood/Blood.tscn")

func _ready():
	next_bleed_distance_sq = rand_range(300, 1000)
	next_bleed_distance_sq = next_bleed_distance_sq * next_bleed_distance_sq

func _physics_process(delta):	
	_velocity = move_and_slide(_velocity)
	_velocity = _velocity * friction
	
	next_bleed_distance_sq -= _velocity.length_squared()
	if next_bleed_distance_sq < 0:
		next_bleed_distance_sq = rand_range(300, 1000)
		next_bleed_distance_sq = next_bleed_distance_sq * next_bleed_distance_sq
		bleed(0.4)

func bleed(scale: float):
	var blood: Node2D = BloodEntity.instance()
	scale *= rand_range(0.06, 0.09) * blood_scale
	blood.scale = Vector2(scale, scale)
	get_parent().get_parent().get_node("Floor").add_child(blood)
	blood.global_position = global_position
