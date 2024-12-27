extends Node

## =============== [ FIELDS ] ================

# Global units array
var units: Array[Unit] = []

## =============== [ METHODS ] ================

# Adds unit to the global unit list
func add_unit(unit: Unit):
	units.append(unit)
