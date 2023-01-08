extends KinematicBody2D
class_name NPC

export var vegetable_type := 0
export(PackedScene) var CorpseEntity
onready var BloodEntity = preload("res://Scenery/Blood/Blood.tscn")

onready var ExclamationMarkEntity := preload("res://Actors/FX/ExclamationMark.tscn")

export var max_health := 2
var health := 2

export var max_alert_time := 10.0
export var sight_distance := 1000.0
export var initial_shock_time := 1.0

export var speed := 100.0
export var friction = 0.1
var _velocity := Vector2.ZERO

var is_scared_target: Node2D = null
var is_alert_time := 0.0
var is_shocked_time := 0.0

onready var attackable: Attackable = $Sprite

func _ready():
	Deaths.connect("on_damage", self, "_on_damage_somewhere")
	health = max_health

func _process(delta):
	is_alert_time -= delta
	is_shocked_time -= delta

	if is_scared_target != null:
		if is_scared_target.global_position.distance_squared_to(global_position) < sight_distance * sight_distance:
			is_alert_time = max_alert_time
		elif is_alert_time < 0:
			is_scared_target = null

func _on_damage_somewhere(victim: Node2D, cause: Node2D):
	if victim.global_position.distance_squared_to(global_position) < sight_distance * sight_distance:
		be_scared_of(cause)

func damage(damage: int, source: Node2D):
	health -= damage
	
	be_scared_of(source)
	Deaths.emit_signal("on_damage", self, source)
	
	if health <= 0:
		var corpse: Corpse = CorpseEntity.instance()
		get_parent().add_child(corpse)
		corpse.global_position = global_position
		
		bleed(1)
		
		queue_free()
		
		Deaths.emit_signal("on_death")
	else:
		bleed(0.5)


func be_scared_of(cause: Node2D):
	if is_alert_time <= 0:
		is_shocked_time = initial_shock_time * rand_range(0.5, 1.0)
	else:
		is_shocked_time = 0.2
	
	is_scared_target = cause
	is_alert_time = max_alert_time
	
	var exclamation_mark := ExclamationMarkEntity.instance()
	exclamation_mark.time_until_death = max(is_shocked_time - 0.05, 0.2)
	add_child(exclamation_mark)
	exclamation_mark.global_position = global_position - Vector2(0, 80)


func bleed(scale: float):
	var blood: Node2D = BloodEntity.instance()
	scale = rand_range(0.06, 0.09) * scale
	blood.scale = Vector2(scale, scale)
	get_parent().get_parent().get_node("Floor").add_child(blood)
	blood.global_position = global_position
