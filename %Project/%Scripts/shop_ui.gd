extends Control

func _on_h_button_pressed() -> void:
	GM.spawn_hydrogen(Vector2(0, 0))

func _on_back_button_pressed() -> void:
	queue_free()

func _on_polarize_button_pressed() -> void:
	get_parent().add_child(load("res://%Project/%Levels/select_unit.tscn").instantiate())
