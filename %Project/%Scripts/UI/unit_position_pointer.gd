extends Sprite2D
var isSelected = false

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

func _on_pointer_area_input_event(viewport: Node, event: InputEvent, shape_idx: int):
	if event is InputEventMouseButton:
		if event.button_index == MOUSE_BUTTON_LEFT:
			isSelected = event.pressed

func _process(delta: float):
	if (isSelected):
		global_position = get_global_mouse_position()
	if Input.is_action_just_released("click"):
		isSelected = false
