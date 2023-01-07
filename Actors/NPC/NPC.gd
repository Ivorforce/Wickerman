extends KinematicBody2D
class_name NPC

var CorpseEntity := preload("res://Actors/Corpse/Corpse.tscn")

export var health := 2

export var speed := 100
export var friction = 0.1
var _velocity := Vector2.ZERO

onready var target := global_position

onready var attackable: Attackable = $Sprite

func _physics_process(delta):
	var direction := target - global_position

	if direction.length_squared() < 20 * 20:
		direction = Vector2.ZERO
		if randf() < 0.01:
			target = global_position + Vector2(rand_range(-100, 100), rand_range(-100, 100))
			direction = target - global_position

	if direction.length() > 1.0:
		direction = direction.normalized()

	var target_velocity = direction * speed
	_velocity += (target_velocity - _velocity) * friction
	_velocity = move_and_slide(_velocity)

func damage(damage: float):
	health -= damage
	
	if health <= 0:
		var corpse: Corpse = CorpseEntity.instance()
		get_parent().add_child(corpse)
		corpse.global_position = global_position
		queue_free()

