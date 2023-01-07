extends Sprite


var images = [
	preload("res://Scenery/Blood/Blood1.png"),
	preload("res://Scenery/Blood/Blood2.png")
]

func _ready():
	texture = images[randi() % images.size()]
