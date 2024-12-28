extends Control

func _on_h_button_pressed() -> void:
	GM.spawn_unit(Vector2(0, 0), GM.unit_spawn_index)

func _on_back_button_pressed() -> void:
	queue_free()

func _on_polarize_button_pressed() -> void:
	get_parent().add_child(load("res://%Project/%Levels/select_unit.tscn").instantiate())

func _on_option_button_item_selected(index: int) -> void:
	GM.unit_spawn_index = index
