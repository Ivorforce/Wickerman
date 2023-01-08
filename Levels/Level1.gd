extends Node2D

onready var CarrotEntity = preload("res://Actors/NPC/Carrot/Carrot.tscn")
onready var OnionEntity = preload("res://Actors/NPC/Onion/Onion.tscn")
onready var PumpkinEntity = preload("res://Actors/NPC/Pumpkin/Pumpkin.tscn")

onready var FoliageEntity = preload("res://Scenery/Foliage/Grass.tscn")

onready var EndScreen = preload("res://TitleScreen/EndScreen.tscn")

onready var entities = $Entities

var time_of_day := 0.0

func _ready():
	for i in range(20):
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

	for i in range(500):
		var entity: Grass = FoliageEntity.instance()
		entity.global_position = Vector2(rand_range(-2000, 2000), rand_range(-2000, 2000))
		
		if (entity.global_position.length() - 500.0) / 500.0 < randf():
			continue  # Too near wickerman
		
		entities.add_child(entity)

func _process(delta):
	# 4m days
	time_of_day += delta / (60.0 * 4.0)

	if time_of_day >= 1:
		get_tree().change_scene_to(EndScreen)
		return

	var sun_pos = cos((time_of_day - 0.4) * PI / 1.25)
	var post_process: PostProcess = $"/root/Game/CanvasLayer/PostProcess"
	post_process.colorization = Vector3(sun_pos, pow(sun_pos, 1.4), pow(sun_pos, 1.6))
	post_process.saturation = min(1.0, sun_pos + 0.5)
