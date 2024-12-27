extends Node2D
class_name Movement

var nearest_unit: Unit
@export var SPEED: float = 10

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	find_nearest_unit()
	if(nearest_unit != null):
		print("Moving from " + str(nearest_unit.position) + " to " + str(global_position))
		
		var new_positon = Vector2(
			move_toward(global_position.x, nearest_unit.position.x, delta*SPEED),
			move_toward(global_position.y, nearest_unit.position.y, delta*SPEED)
		)
		position = new_positon


func find_nearest_unit() -> void:
	# set nearest_unit to be nearest unit
	var closest_distance: float = 999999999999
	print("finding unit in " + str(GM.units) + "...")
	for unit in GM.units:
		print("Distance is " + str(position.distance_to(unit.position)))
		if(position.distance_to(unit.position) < closest_distance and unit != self):
			closest_distance = position.distance_to(unit.position)
			nearest_unit = unit	
			print("unit found!")
