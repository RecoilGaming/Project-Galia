extends Node

## =============== [ FIELDS ] ================

# Scenes
@onready var main: Node2D = get_tree().root.get_node("Main")

# Units
var coins: int = 100
var units: Array[Unit] = []
var click_polarity: int = 1
var unit_spawn_index: int = 0
var types = ["hydrogen", "oxygen", "fluorine"]
var polarizing: bool = false

func _ready():
	update_coins()

## =============== [ METHODS ] ================

# Add unit
func add_unit(unit: Unit):
	units.append(unit)

# Spawn unit
func spawn_unit(pos: Vector2, index: int):
	if coins >= 3:
		# Instantiate unit
		var unit: Unit = load("res://%Project/Characters/" + types[index] + ".tscn").instantiate()
		unit.position = pos
		
		# Add child
		main.add_child(unit)
		
		# Subtract cost
		coins -= 3
		update_coins()

func update_coins():
	main.get_node("CoinText").text = "coins: " + str(coins)
