extends Node2D
class_name Unit

## =============== [ FIELDS ] ================

# Attributes
@export var speed: float = 100
@export var health: int = 100
@export var unit_faction: FACTION
enum FACTION {NEGATIVE, POSITIVE}

# Target unit
var target: Unit

## =============== [ METHODS ] ================

# Ready
func _ready() -> void:
	# Adds a unit to the list of all units in the GameManager
	GM.add_unit(self)

# Process
func _process(delta: float) -> void:
	# Find target
	find_target()
	
	# Track target
	if target:
		var _position = global_position.move_toward(target.global_position, speed*delta)
		global_position = _position

# Finds the nearest target
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
