extends Control

func _on_unit_dropdown_ready():
	$ColorRect/UnitDropdown.select(GM.last_purchased)
	GM.is_summoning = true

func _on_unit_dropdown_item_selected(index: int):
	GM.last_purchased = index

func _on_back_button_pressed() -> void:
	GM.is_summoning = false
	queue_free()
