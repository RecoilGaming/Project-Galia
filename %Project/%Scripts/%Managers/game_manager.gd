extends Node

## =============== [ FIELDS ] ================

# Global units array
var units: Array[Unit] = []
var unit_cap = 5

## =============== [ METHODS ] ================

# Add unit
func add_unit(unit: Unit):
	units.append(unit)

func add_hydrogen():
	unit_cap -= 1
	print(unit_cap)
