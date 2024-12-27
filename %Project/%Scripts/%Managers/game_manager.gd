extends Node

## =============== [ FIELDS ] ================

# Global units array
var units: Array[Unit] = []
var unit_cap: int = 5

## =============== [ METHODS ] ================

# Add unit
func add_unit(unit: Unit):
	units.append(unit)

# Spawn hydrogen
func spawn_hydrogen(pos: Vector2):
	var hydrogen: Unit = load("res://%Project/Characters/unit.tscn").instantiate()
	get_tree().root.add_child(hydrogen)
	unit_cap -= 1
