extends Control

func _ready() -> void:
	GM.is_selling = true

func _on_back_button_pressed() -> void:
	GM.is_selling = false
	queue_free()
