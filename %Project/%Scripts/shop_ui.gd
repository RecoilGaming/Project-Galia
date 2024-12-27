extends Control

func _on_h_button_pressed() -> void:
	GM.add_hydrogen()

func _on_back_button_pressed() -> void:
	queue_free()
