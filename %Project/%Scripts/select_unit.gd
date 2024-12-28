extends Control


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _on_back_button_pressed() -> void:
	#get_parent().add_child(load("res://%Project/%Levels/shop.tscn").instantiate())
	queue_free()

func _on_polarity_toggle_toggled(toggled_on: bool) -> void:
	GM.click_polarity = 1 if toggled_on else -1
