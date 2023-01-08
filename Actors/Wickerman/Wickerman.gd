extends KinematicBody2D
class_name Wickerman


onready var demand_speech_bubble: DemandText = $"../../WickermanDemandText"

var current_demand: NPC = null

var demand_for_satisfaction_count := 4
var sacrifice_count := 0
var time_until_demand := -1.0


func _ready():
	time_until_demand = 3.0
	demand_speech_bubble.set_text("The Wickerman awakens.")

func _process(delta):
	if time_until_demand > 0:
		time_until_demand -= delta
		if time_until_demand < 0:
			next_demand()

func next_demand():
	var vegetable_type := randi() % 3

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

func light_on_fire():
	var post_process: PostProcess = $"/root/Game/CanvasLayer/PostProcess"
	var game: Level1 = $"/root/Game/Level1"
	
	post_process.screen_flash_s = 0.1
	post_process.screen_shake_s = 0.2
	
	demand_speech_bubble.set_text("")
	current_demand = null
	
	if sacrifice_count >= demand_for_satisfaction_count:
		demand_speech_bubble.set_text("The Wickerman is satisfied.")
		game.end_day_slowly(null)
		
		sacrifice_count = 0
		demand_for_satisfaction_count += randi() % 3 + 1
	else:
		demand_speech_bubble.set_text("The Wickerman is dissatisfied.")
		game.end_day_slowly("The Wickerman punished you.")
