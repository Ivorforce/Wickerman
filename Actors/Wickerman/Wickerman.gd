extends KinematicBody2D
class_name Wickerman

onready var CarrotEntity = preload("res://Actors/NPC/Carrot/Carrot.tscn")
onready var OnionEntity = preload("res://Actors/NPC/Onion/Onion.tscn")
onready var PumpkinEntity = preload("res://Actors/NPC/Pumpkin/Pumpkin.tscn")


var current_demand: NPC = null

onready var demand_speech_bubble = $"../../WickermanDemandSpeech"


func _ready():
	next_demand()

func next_demand():
	var EntityType = [CarrotEntity, OnionEntity, PumpkinEntity][randi() % 3]
	
	current_demand = EntityType.instance()
	current_demand.get_node("MovementController").queue_free()
	current_demand.get_node("CollisionShape2D").queue_free()
	demand_speech_bubble.add_child(current_demand)

func try_sacrifice(corpse: Corpse):
	if current_demand == null:
		return
	
	if current_demand.vegetable_type == corpse.vegetable_type:		
		Freezer.next_freeze_s += 0.05
		
		var post_process: PostProcess = $"/root/Game/PostProcess"
		post_process.screen_flash_s = 0.1
		post_process.screen_shake_s = 0.2
		
		corpse.queue_free()
		
		current_demand.queue_free()
		next_demand()
