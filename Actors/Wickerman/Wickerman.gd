extends KinematicBody2D
class_name Wickerman

onready var CarrotEntity = preload("res://Actors/NPC/Carrot/Carrot.tscn")
onready var OnionEntity = preload("res://Actors/NPC/Onion/Onion.tscn")
onready var PumpkinEntity = preload("res://Actors/NPC/Pumpkin/Pumpkin.tscn")


onready var demand_image_bubble = $"../../WickermanDemandImage"
onready var demand_speech_bubble: DemandText = $"../../WickermanDemandText"

onready var game: Level1

var current_demand: NPC = null

var demand_for_satisfaction_count := 4
var sacrifice_count := 0


func _ready():
	next_demand()

func next_demand():
	var vegetable_type := randi() % 3
	var EntityType = [CarrotEntity, OnionEntity, PumpkinEntity][vegetable_type]
	
	current_demand = EntityType.instance()
	current_demand.get_node("MovementController").queue_free()
	current_demand.get_node("CollisionShape2D").queue_free()
	demand_image_bubble.add_child(current_demand)

	var text = "The Wickerman demands a carrot." if vegetable_type == 0 else \
		"The Wickerman demands an onion." if vegetable_type == 1 else \
		"The Wickerman demands a pumpkin."
	demand_speech_bubble.set_text(text)

func try_sacrifice(corpse: Corpse):
	if current_demand == null:
		return
	
	if current_demand.vegetable_type == corpse.vegetable_type:		
		Freezer.next_freeze_s += 0.05
		
		var post_process: PostProcess = $"/root/Game/CanvasLayer/PostProcess"
		post_process.screen_flash_s = 0.1
		post_process.screen_shake_s = 0.2
		
		corpse.queue_free()
		
		current_demand.queue_free()
		next_demand()
