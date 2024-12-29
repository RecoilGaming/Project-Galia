extends Control

func _on_back_button_pressed():
	queue_free()

func _on_polarize_button_pressed():
	get_parent().add_child(load("res://%Project/%Levels/select_unit.tscn").instantiate())
	queue_free()

func _on_add_unit_button_pressed():
	get_parent().add_child(load("res://%Project/%Levels/add_unit.tscn").instantiate())
	queue_free()

func _on_area_2d_input_event(_viewport: Node, event: InputEvent, _shape_idx: int) -> void:
	if (event is InputEventMouseButton
	 and event.button_index == MOUSE_BUTTON_LEFT
	 and event.pressed
	 and !event.canceled):
			if (GM.adding_window_open):
				GM.try_to_spawn(GM.types[GM.unit_spawn_index], event.position - Vector2(640, 360)/2, false)
