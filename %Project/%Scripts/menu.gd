extends Control

func _input(event):
	if event is InputEventKey and event.pressed:
		match event.keycode:
			KEY_VOLUMEUP, KEY_VOLUMEDOWN, KEY_VOLUMEMUTE:
				pass
			_:
				GM.play_theme()
				GM.prepare_wave()
				queue_free()
