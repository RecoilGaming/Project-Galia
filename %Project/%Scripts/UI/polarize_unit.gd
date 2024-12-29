extends Control

func _ready():
	GM.is_polarizing = true

func _on_back_button_pressed():
	GM.is_polarizing = false
	queue_free()
