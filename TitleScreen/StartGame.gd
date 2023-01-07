extends Button


func _on_Start_pressed():
	randomize()
	get_tree().change_scene("res://Levels/Main.tscn")
