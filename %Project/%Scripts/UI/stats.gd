extends Control

func _on_back_button_pressed():
	queue_free()

#func _ready():
	#get_node("ColorRect/Prices").text = "%d\n%d\n%d\n%d\n%d" % [
		#GM.unit_price[0],
		#GM.unit_price[1],
		#GM.unit_price[2],
		#GM.unit_price[3],
		#GM.unit_price[4]
	#]
