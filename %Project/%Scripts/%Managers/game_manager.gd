extends Node

## =============== [ FIELDS ] ================

# Scenes
@onready var main: Node2D = get_tree().root.get_node("Main")

# Units
var units: Array[Unit] = []
var unit_cap: int = 5

## =============== [ METHODS ] ================

# Add unit
func add_unit(unit: Unit):
	units.append(unit)

# Spawn hydrogen
func spawn_hydrogen(pos: Vector2):
	if unit_cap > 0:
		# Instantiate hydrogen
		var hydrogen: Unit = load("res://%Project/Characters/hydrogen.tscn").instantiate()
		hydrogen.position = pos
		main.add_child(hydrogen)
		main.move_child(hydrogen, 0)
		
		# Decrease unit cap
		unit_cap -= 1
