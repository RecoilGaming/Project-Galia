extends Node2D

func _ready():
	show()

func _on_area_2d_input_event(_viewport: Node, event: InputEvent, _shape_idx: int):
	if (
		event is InputEventMouseButton
		and event.button_index == MOUSE_BUTTON_LEFT
		and event.pressed
		and !event.canceled
		and GM.is_summoning
	):
		GM.spawn_unit(GM.last_purchased, event.position - Vector2(320, 180))
