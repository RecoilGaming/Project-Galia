extends Control

func _ready():
	GM.polarizing = true

func _on_back_button_pressed():
	GM.polarizing = false
	queue_free()
