extends KinematicBody2D

onready var CarrotEntity = preload("res://Actors/NPC/Carrot/Carrot.tscn")
onready var OnionEntity = preload("res://Actors/NPC/Onion/Onion.tscn")
onready var PumpkinEntity = preload("res://Actors/NPC/Pumpkin/Pumpkin.tscn")


var current_demand_type: NPC = null

onready var demand_speech_bubble = $"../../WickermanDemandSpeech"


func _ready():
	next_demand()

func next_demand():
	current_demand_type = CarrotEntity.instance()
	current_demand_type.get_node("MovementController").queue_free()
	current_demand_type.get_node("CollisionShape2D").queue_free()
	current_demand_type.get_node("HitBox").queue_free()
	demand_speech_bubble.add_child(current_demand_type)
