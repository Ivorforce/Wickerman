extends Node2D
 
export(String, FILE) var entity_path
onready var entity_type = load(entity_path)

export var min_count := 1
export var max_count := 10

export var spawn_range := 200

func _ready():
	for i in range(min_count + (randi() % (max_count - min_count + 1))):
		var entity: Node2D = entity_type.instance()
		entity.position = position + Vector2(rand_range(-spawn_range, spawn_range), rand_range(-spawn_range, spawn_range))
		get_parent().call_deferred("add_child", entity)

	queue_free()
