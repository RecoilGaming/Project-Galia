extends Sprite2D
var isSelected = false

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

func _on_pointer_area_input_event(_viewport: Node, event: InputEvent, _shape_idx: int):
	if event is InputEventMouseButton:
		if event.button_index == MOUSE_BUTTON_LEFT:
			isSelected = event.pressed

func _process(_delta: float):
	if (isSelected):
		global_position = get_global_mouse_position()
	if not Input.is_mouse_button_pressed(MOUSE_BUTTON_LEFT):
		isSelected = false
	var valid: bool = GM.can_spawn(global_position)
	flip_h = !valid
	flip_v = !valid
