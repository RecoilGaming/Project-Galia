extends Unit
class_name Hydrogen

func _on_input_event(viewport: Node, event: InputEvent, shape_idx: int) -> void:
	if event.is_pressed() and event.button_index == MOUSE_BUTTON_LEFT:
		change_polarity(1)
