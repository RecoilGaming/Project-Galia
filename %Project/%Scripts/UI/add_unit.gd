extends Control

func _on_unit_dropdown_ready():
	$ColorRect/UnitDropdown.select(GM.unit_spawn_index)

func _on_add_button_pressed():
	GM.spawn_unit($Pointer.global_position, GM.unit_spawn_index)

func _on_unit_dropdown_item_selected(index: int):
	GM.unit_spawn_index = index


func _on_back_button_pressed() -> void:
	get_parent().add_child(load("res://%Project/%Levels/shop.tscn").instantiate())
	queue_free()	