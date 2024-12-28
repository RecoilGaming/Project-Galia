extends Node

## =============== [ FIELDS ] ================

# Scenes
@onready var main: Node2D = get_tree().root.get_node("Main")

# Units
var coins: int = 100
var units: Array[Unit] = []
var click_polarity: int = 1
var unit_spawn_index: int = 0

## =============== [ METHODS ] ================

# Add unit
func add_unit(unit: Unit):
	units.append(unit)

# Spawn hydrogen
func spawn_hydrogen(pos: Vector2):
	if coins >= 3:
		# Instantiate hydrogen
		var hydrogen: Hydrogen = load("res://%Project/Characters/hydrogen.tscn").instantiate()
		hydrogen.position = pos
		
		# Add child
		main.add_child(hydrogen)
		main.move_child(hydrogen, 0)
		
		# Subtract cost
		coins -= 3
