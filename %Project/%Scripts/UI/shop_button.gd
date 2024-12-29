extends Button

func _on_pressed() -> void:
	if GM.polarizing_window_open:
		get_parent().get_node("SelectUnit")._on_back_button_pressed()
	if GM.adding_window_open:
		get_parent().get_node("AddUnit")._on_back_button_pressed()
	get_parent().add_child(load("res://%Project/%Levels/shop.tscn").instantiate())
