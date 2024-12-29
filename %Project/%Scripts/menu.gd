extends Control

func _input(event):
	if event is InputEventKey and event.pressed:
		GM.play_theme()
		queue_free()
