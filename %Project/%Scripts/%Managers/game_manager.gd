extends Node

## =============== [ FIELDS ] ================

# Global units array
var units: Array[Unit] = []

## =============== [ METHODS ] ================

# Add unit
func add_unit(unit: Unit):
	units.append(unit)
