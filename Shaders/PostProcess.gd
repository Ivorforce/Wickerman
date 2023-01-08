extends ColorRect
class_name PostProcess

var screen_flash_s := 0.0
var screen_shake_s := 0.0

var screen_shake_dir = Vector2.ZERO
var time_until_shake_dir = 0.0

var saturation := 1.0
var colorization := Vector3(1.0, 1.0, 1.0)

func _process(delta):
	screen_flash_s = max(screen_flash_s - delta, 0.0)
	screen_shake_s = max(screen_shake_s - delta, 0.0)
	
	if screen_shake_s > 0.0:
		time_until_shake_dir -= delta
		if time_until_shake_dir <= 0.0:
			screen_shake_dir = Vector2(rand_range(-0.003, 0.003), rand_range(-0.003, 0.003))
			time_until_shake_dir = 0.02
	else:
		screen_shake_dir = Vector2.ZERO

	material.set_shader_param("whitening", screen_flash_s)
	material.set_shader_param("tex_offset", screen_shake_dir)
	material.set_shader_param("saturation", saturation)
	material.set_shader_param("colorization", colorization)
