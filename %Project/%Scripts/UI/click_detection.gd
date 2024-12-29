extends Node2D

func _on_area_2d_input_event(_viewport: Node, event: InputEvent, _shape_idx: int):
	if (event is InputEventMouseButton
	 and event.button_index == MOUSE_BUTTON_LEFT
	 and event.pressed
	 and !event.canceled):
			if (GM.adding_window_open):
				GM.try_to_spawn(GM.types[GM.unit_spawn_index], event.position - Vector2(640, 360)/2, false)
