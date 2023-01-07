extends KinematicBody2D
class_name NPC

export var vegetable_type := 0
export(PackedScene) var CorpseEntity

export var health := 2

export var speed := 100
export var friction = 0.1
var _velocity := Vector2.ZERO

onready var attackable: Attackable = $Sprite


func damage(damage: int):
	health -= damage
	
	if health <= 0:
		var corpse: Corpse = CorpseEntity.instance()
		get_parent().add_child(corpse)
		corpse.global_position = global_position
		queue_free()
