extends KinematicBody2D
class_name NPC

export var vegetable_type := 0
export(PackedScene) var CorpseEntity

export var health := 2
export var max_alert_time := 10
export var sight_distance := 1000

export var speed := 100
export var friction = 0.1
var _velocity := Vector2.ZERO

var is_scared_target: Node2D = null
var is_alert_time := 0.0

onready var attackable: Attackable = $Sprite

func _ready():
	Deaths.connect("on_damage", self, "_on_damage_somewhere")

func _process(delta):
	is_alert_time -= delta

	if is_scared_target != null:
		if is_scared_target.global_position.distance_squared_to(global_position) < sight_distance * sight_distance:
			is_alert_time = max_alert_time
		elif is_alert_time < 0:
			is_scared_target = null

func _on_damage_somewhere(victim: Node2D, cause: Node2D):
	if victim.global_position.distance_squared_to(global_position) < sight_distance * sight_distance:
		is_scared_target = cause
		is_alert_time = max_alert_time

func damage(damage: int, source: Node2D):
	health -= damage
	
	is_scared_target = source
	is_alert_time = max_alert_time
	
	Deaths.emit_signal("on_damage", self, source)
	
	if health <= 0:
		var corpse: Corpse = CorpseEntity.instance()
		get_parent().add_child(corpse)
		corpse.global_position = global_position
		queue_free()
		
		Deaths.emit_signal("on_death")
