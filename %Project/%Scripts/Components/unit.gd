extends Node2D
class_name Unit

## =============== [ FIELDS ] ================

# Attributes
@export var speed: float = 100

# Target unit
var target: Unit

## =============== [ METHODS ] ================

# Ready
func _ready() -> void:
	GM.add_unit(self)

# Process
func _process(delta: float) -> void:
	# Find target
	find_target()
	
	# Track target
	if target:
		var _position = Vector2(
			move_toward(global_position.x, target.global_position.x, speed * delta),
			move_toward(global_position.y, target.global_position.y, speed * delta)
		)
		
		global_position = _position

# Find target
func find_target() -> void:
	# Minimum distance
	var min_dist: float = 1000000
	
	# Loop through units
	for unit in GM.units:
		# Get distance
		var dist: float = global_position.distance_to(unit.global_position)
		
		# Check unit
		if unit != self and dist < min_dist:
			min_dist = dist
			target = unit
