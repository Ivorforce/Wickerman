extends Label
class_name DemandText


func set_text(text: String):
	$Tween.stop_all()
	
	self.percent_visible = 0
	self.text = text
	$Tween.interpolate_property(
		self, "percent_visible",
		0, 1, 3, Tween.TRANS_CUBIC, Tween.EASE_IN_OUT
	)
	$Tween.start()
