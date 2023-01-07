extends Node2D

onready var CarrotEntity = preload("res://Actors/NPC/Carrot/Carrot.tscn")
onready var OnionEntity = preload("res://Actors/NPC/Onion/Onion.tscn")
onready var PumpkinEntity = preload("res://Actors/NPC/Pumpkin/Pumpkin.tscn")

onready var entities = $Entities

func _ready():
	for i in range(20):
		var center := Vector2(rand_range(-1500, 1500), rand_range(-1500, 1500))
		
		var vegetable_type := randi() % 3
		var EntityType = [CarrotEntity, OnionEntity, PumpkinEntity][vegetable_type]
		var max_num = 10 if vegetable_type == 0 else \
			6 if vegetable_type == 1 else \
			4
		
		for j in range(randi() % max_num + 1):
			var entity: NPC = EntityType.instance()
			entity.global_position = center + Vector2(rand_range(-200, 200), rand_range(-200, 200))
			entities.add_child(entity)
