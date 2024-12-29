extends Node

## =============== [ FIELDS ] ================

# Scenes
@onready var main: Node2D = get_tree().root.get_node("Main")

# Shop
var coins: int = 100:
	set(value):
		coins = value
		update_coins()

var last_purchased: int = 0
var is_polarizing: bool = false
var is_summoning: bool = false

# Units
var units: Array[Unit] = []
var unit_map: Dictionary = {
	0 : "hydrogen",
	1 : "oxygen",
	2 : "fluorine",
	3 : "uranium",
	4 : "tungsten"
}
var price_map: Dictionary = {
	"hydrogen" : 5,
	"oxygen" : 15,
	"fluorine" : 10,
	"uranium" : 15,
	"tungsten" : 20
}

# Waves
var cur_wave: int= 0
var waves: Array = [
	[[0, 3]],
	[[0, 3], [1, 2]],
	[[0, 5], [1, 4]],
	[[0, 3], [1, 2], [2, 2]],
	[[1, 5], [4, 2]],
	[[3, 10]],
	[[0, 5], [1, 5], [2, 5], [3, 5], [4, 5]],
	[[0, 30], [1, 20]],
]

## =============== [ METHODS ] ================ ##

# Ready
func _ready():
	# Spawn main menu
	var menu: Control = load("res://%Project/%Levels/menu.tscn").instantiate()
	main.add_child.call_deferred(menu)
	#update_coins()

## =============== [ HELPERS ] ================ ##

# Update coins
func update_coins():
	main.get_node("MainUI/CoinText").text = str(coins)

# Add unit to global map
func add_unit(unit: Unit):
	units.append(unit)

# Spawn unit with subtract coins
func spawn_unit(id: int, pos: Vector2):
	# Grab unit
	var price: int = price_map[unit_map[id]]
	
	# Enough coins check
	if coins >= price:
		# Subtract coins on successful spawn
		if attempt_spawn(id, pos, false):
			coins -= price

# Attempts a spawn
func attempt_spawn(id: int, pos: Vector2, is_enemy: bool) -> bool:
	# Check for spawning space
	for unit in units:
		# Distance check
		var dist = unit.global_position.distance_to(pos)
		if dist < 30:
			return false
	
	# Instantiate unit
	var _unit: Unit = load("res://%Project/Characters/" + unit_map[id] + ".tscn").instantiate()
	_unit.position = pos
	_unit.polarity = randi_range(0, 1)*2 - 1
	_unit.IS_ENEMY = is_enemy
	
	# Add instance
	main.add_child.call_deferred(_unit)
	
	# Successful spawn
	return true

# Spawns a wave
func spawn_wave():
	# Resume game
	Engine.set_time_scale(1)
	
	## TODO: Replace with actual wave spawner
	var _wave: Array = waves[cur_wave]
	
	# TEMP HARDCODED WAVES
	for unit in _wave:
		var id: int = unit[0]
		
		for i in range(0, unit[1]):
			var pos: Vector2 = Vector2(
				randi_range(30, 290),
				randi_range(-150, 150)
			)
			
			if !attempt_spawn(id, pos, true):
				i -= 1
	
	# Increment wave
	cur_wave += 1

# Check for surviving enemies
func enemies_alive() -> int:
	var amt: int = 0
	for unit in units:
		if unit.IS_ENEMY:
			amt += 1
	return amt

# Check for surviving allies
func allies_alive() -> int:
	var amt: int = 0
	for unit in units:
		if !unit.IS_ENEMY:
			amt += 1
	return amt

# Check / end wave
func clean_wave() -> void:
	# Check for surviving enemies
	if enemies_alive():
		# Lose condition
		if !allies_alive() && coins == 0:
			get_tree().quit()
	
	# End wave and pause game
	else:
		main.get_node("MainUI/GoButton").show()
		Engine.set_time_scale(0)

# Start theme song
func play_theme() -> void:
	main.get_node("Sounds").stream = load("res://%Project/Resources/Sounds/poland_theme.mp3")
	main.get_node("Sounds").play()

## =============== [ SIGNALS ] ================ ##

# Start next wave
func _on_go_button_pressed() -> void:
	spawn_wave()
	main.get_node("MainUI/GoButton").hide()
