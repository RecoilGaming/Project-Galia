extends Control

func _on_unit_dropdown_ready():
	$ColorRect/UnitDropdown.select(GM.unit_spawn_index)
	GM.adding_window_open = true

func _on_unit_dropdown_item_selected(index: int):
	GM.unit_spawn_index = index

func _on_back_button_pressed() -> void:
	GM.adding_window_open = false
	queue_free()
