extends Control

func _on_back_button_pressed():
	queue_free()

func _on_polarize_button_pressed():
	get_parent().add_child(load("res://%Project/%Levels/select_unit.tscn").instantiate())
	queue_free()

func _on_add_unit_button_pressed():
	get_parent().add_child(load("res://%Project/%Levels/add_unit.tscn").instantiate())
	queue_free()
