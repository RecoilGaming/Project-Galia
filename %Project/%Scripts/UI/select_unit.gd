extends Control

func _ready():
	GM.polarizing_window_open = true

func _on_back_button_pressed():
	GM.polarizing_window_open = false
	queue_free()
