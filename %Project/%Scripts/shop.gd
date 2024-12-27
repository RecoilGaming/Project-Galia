extends Control


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _on_menu_button_pressed() -> void:
	print("hello")
	var shop = $ShopWindow
	shop.show()
	pass


func _on_shop_window_close_requested() -> void:
	var shop = $ShopWindow
	shop.hide()
	pass # Replace with function body.
