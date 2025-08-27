extends AudioStreamPlayer


func click(high: bool) -> void:
	if high:
		pitch_scale = 1.0
	else:
		pitch_scale = 0.7
	play()
