extends Button

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func _on_pressed() -> void:
	if GM.polarizing:
		get_parent().get_node("SelectUnit")._on_back_button_pressed()
	get_parent().add_child(load("res://%Project/%Levels/shop.tscn").instantiate())
