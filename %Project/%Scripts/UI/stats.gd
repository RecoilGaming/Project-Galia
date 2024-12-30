extends Control

func _ready():
	GM.is_viewing_stats = true

func _on_back_button_pressed():
	GM.is_viewing_stats = false
	queue_free()
