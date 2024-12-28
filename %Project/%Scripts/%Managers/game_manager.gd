extends Node

## =============== [ FIELDS ] ================

# Scenes
@onready var main: Node2D = get_tree().root.get_node("Main")

# Units
var coins: int = 100:
	set(value):
		coins = value
		update_coins()
var units: Array[Unit] = []
var click_polarity: int = 1
var unit_spawn_index: int = 0
var types = ["hydrogen", "oxygen", "fluorine"]
var polarizing: bool = false

var current_wave := 1
var waves = [
	[["hydrogen", 5]],
	[["hydrogen", 3], ["oxygen", 2]],
	[["hydrogen", 5], ["oxygen", 4]],
	[["hydrogen", 3], ["oxygen", 2], ["fluorine", 2]],
	[["hydrogen", 3], ["oxygen", 0], ["fluorine", 5]],
]

var waiting_for_continue := false

func _ready():
	update_coins()
	new_wave()

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

func update_coins():
	main.get_node("CoinText").text = "Coins: " + str(coins)

func try_to_spawn(u: String, x: float, y: float) -> bool:
	for unit in units:
		var distance = unit.global_position.distance_to(Vector2(x, y))
		if(distance < 30):
			return false

	# Instantiate unit
	var unit: Unit = load("res://%Project/Characters/" + u + ".tscn").instantiate()
	unit.position = Vector2(x, y)
	
	# Add child
	main.add_child(unit)
	return true

func new_wave():
	Engine.set_time_scale(0)
	waiting_for_continue = true
	var wave_to_spawn = waves[current_wave]
	
	for spawn in wave_to_spawn:
		var unit_class = spawn[0]
		var i := 0
		while i < spawn[1]:
			if(try_to_spawn(unit_class, randi_range(30, 290), randi_range(-150, 150))): # -320, -180 to 320, 180 is the canvas
				i += 1
				
	current_wave += 1
