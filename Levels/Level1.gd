extends Node2D
class_name Level1

onready var CarrotEntity = preload("res://Actors/NPC/Carrot/Carrot.tscn")
onready var OnionEntity = preload("res://Actors/NPC/Onion/Onion.tscn")
onready var PumpkinEntity = preload("res://Actors/NPC/Pumpkin/Pumpkin.tscn")

onready var FoliageEntity = preload("res://Scenery/Foliage/Grass.tscn")

onready var EndScreen = preload("res://TitleScreen/EndScreen.tscn")

	
onready var entities = $Entities

export var fire_hint_text_path: NodePath
onready var fire_hint_text: Label = get_node(fire_hint_text_path)

var time_of_day := 0.0
var days_passed = 0
var time_until_warn_flash := 0.0
var shown_fire_hint_text = false

var time_until_end_day := -1.0
var failure_reason = null


var warnings_left := 2


func _ready():
	spawn_veggies(30)
	
	for i in range(100):
		var entity: Grass = FoliageEntity.instance()
		entity.position = Vector2(rand_range(-2000, 2000), rand_range(-2000, 2000))
		
		if (entity.position.length() - 500.0) / 500.0 < randf():
			continue  # Too near wickerman
		
		entities.add_child(entity)
	
func spawn_veggies(num: int):
	for i in range(num):
		var center := Vector2(rand_range(-1500, 1500), rand_range(-1500, 1500))
		
		if (center.length() - 100.0) / 500.0 < randf():
			continue  # Too near wickerman
			
		var vegetable_type := randi() % 3
		var EntityType = [CarrotEntity, OnionEntity, PumpkinEntity][vegetable_type]
		var max_num = 10 if vegetable_type == 0 else \
			6 if vegetable_type == 1 else \
			4
		
		for j in range(randi() % max_num + 1):
			var entity: NPC = EntityType.instance()
			entity.global_position = center + Vector2(rand_range(-200, 200), rand_range(-200, 200))
			entities.add_child(entity)


func _process(delta):
	if time_of_day >= 0.95 or time_until_end_day >= 0.0:
		time_until_warn_flash -= delta
		if time_until_warn_flash <= 0:
			Freezer.freeze_s = 0.05
			var post_process: PostProcess = $"/root/Game/CanvasLayer/PostProcess"
			post_process.flash(0.05)
			post_process.screen_shake_s = 0.25
			time_until_warn_flash = 1
			
	if time_until_end_day >= 0:
		time_until_end_day -= delta
		if time_until_end_day <= 0:
			end_day()
		return
	
	# 3m days
	time_of_day += delta / (60.0 * 3.0)

	if time_of_day >= 1:
		die_of_cold()
		return

	if time_of_day >= 0.9 and not shown_fire_hint_text:
		var tween: Tween = fire_hint_text.get_child(0)
		tween.stop_all()
		
		fire_hint_text.percent_visible = 0
		tween.interpolate_property(
			fire_hint_text, "percent_visible",
			0, 1, 3, Tween.TRANS_CUBIC
		)
		tween.start()
		shown_fire_hint_text = true

	var sun_pos = cos((time_of_day - 0.4) * PI / 1.25)
	var post_process: PostProcess = $"/root/Game/CanvasLayer/PostProcess"
	post_process.colorization = Vector3(sun_pos, pow(sun_pos, 1.4), pow(sun_pos, 1.6))
	post_process.saturation = min(1.0, sun_pos + 0.5)

func die_of_cold():
	GameResults.text = "You froze to death." + days_lasted_text()
	get_tree().change_scene_to(EndScreen)

func end_day_slowly(failure_reason):
	self.failure_reason = failure_reason
	time_until_end_day = 5

func end_day():
	if failure_reason != null:
		GameResults.text = failure_reason + days_lasted_text()
		get_tree().change_scene_to(EndScreen)
		return
	
	fire_hint_text.visible = false
	failure_reason = null
	time_of_day = 0

	var post_process: PostProcess = $"/root/Game/CanvasLayer/PostProcess"
	post_process.flash(1.0)
	post_process.screen_shake_s = 1.0
	
	spawn_veggies(2)
	
	# Can't type hint for whatever reason
	var wickerman = $"/root/Game/Level1/Entities/Wickerman"
	var player = $"/root/Game/Level1/Entities/Player"

	player.change_to_scythe()
	wickerman.time_until_demand = 4.0
	wickerman.demand_speech_bubble.set_text("The Wickerman is hungry.")

func on_enrage():
	if warnings_left < 1:
		GameResults.text = "You enraged the Wickerman." + days_lasted_text()
		get_tree().change_scene_to(EndScreen)
		return

	var post_process: PostProcess = $"/root/Game/CanvasLayer/PostProcess"
	post_process.flash(0.05)
	post_process.screen_shake_s = 0.25
	warnings_left -= 1

func days_lasted_text() -> String:
	if days_passed == 0: 
		return "\nYou didn't last a single day."
	elif days_passed == 1:
		return "\nYou lasted a single day."
	else:
		return "\nYou lasted %d days." % days_passed
