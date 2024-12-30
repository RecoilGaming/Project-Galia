extends Node

## =============== [ FIELDS ] ================

# Scenes
@onready var main: Node2D = get_tree().root.get_node("Main")

# Shop
var coins: int = 30:
	set(_coins):
		coins = _coins
		update_coins()

var last_purchased: int = 0
var is_polarizing: bool = false
var is_summoning: bool = false
var is_selling: bool = false

# Units
var units: Array[Unit] = []

var unit_name: Dictionary = {
	0 : "hydrogen",
	1 : "oxygen",
	2 : "fluorine",
	3 : "uranium",
	4 : "tungsten"
}

var unit_price: Dictionary = {
	0 : 10,
	1 : 40,
	2 : 35,
	3 : 80,
	4 : 110
}

# Waves
var cur_wave: int = 0:
	set(value):
		cur_wave = value
		main.get_node("MainUI/WaveText").text = "Wave " + str(cur_wave+1)
var wave_value: float = 25 # Determines amount spawned
var wave_scaler: float = 1.3 # Amount of wave value increase
var wave_yields: float = 0.8 # Amount of wave value given to player
var is_cleaing: bool = false
var lose_timer: float = 10000000

## =============== [ METHODS ] ================ ##

# Ready
func _ready():
	update_coins()
	
	# Spawn main menu
	var menu: Control = load("res://%Project/%Levels/menu.tscn").instantiate()
	main.add_child(menu)
	#update_coins()

# Process
func _process(delta: float) -> void:
	# Update timers
	lose_timer -= delta
	
	# Losing
	if lose_timer < 0:
		if enemies_alive() && !allies_alive() && coins < unit_price[0]:
			get_tree().quit()
		else:
			lose_timer = 10000000

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
	var price: int = unit_price[id]
	
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
	var _unit: Unit = load("res://%Project/Characters/" + unit_name[id] + ".tscn").instantiate()
	_unit.position = pos
	_unit.polarity = randi_range(0, 1)*2 - 1
	_unit.is_enemy = is_enemy
	
	# Add instance
	main.add_child.call_deferred(_unit)
	
	# Successful spawn
	return true

# Starts a wave
func start_wave():
	# Resume game
	Engine.set_time_scale(1)

# Prepare wave
func prepare_wave() -> void:
	var temp_value: int = wave_value
	
	# While there is usable value
	while temp_value >= unit_price[0]:
		# Get random unit
		var id: int = randi_range(0, 4)
		
		# Random position
		var pos: Vector2 = Vector2(
			randi_range(30, 290),
			randi_range(-150, 150)
		)
		
		# Check price and spawn conditions
		if unit_price[id] <= temp_value && attempt_spawn(id, pos, true):
			temp_value -= unit_price[id]
	
	# Show next wave button
	main.get_node("MainUI/GoButton").show()
	Engine.set_time_scale(0)

# Check for surviving enemies
func enemies_alive() -> int:
	var amt: int = 0
	for unit in units:
		if unit.is_enemy:
			amt += 1
	return amt

# Check for surviving allies
func allies_alive() -> int:
	var amt: int = 0
	for unit in units:
		if !unit.is_enemy:
			amt += 1
	return amt

# Check / end wave
func clean_wave() -> void:
	# Check for surviving enemies
	if enemies_alive():
		# Lose condition
		if !allies_alive() && coins < unit_price[0]:
			lose_timer = 0.2
	
	# End wave and pause game
	else:
		# Scale difficulty & distribute rewards
		wave_value *= wave_scaler
		coins += wave_value * wave_yields
		
		# Increment wave
		cur_wave += 1
		
		# Prepare next wave
		await get_tree().create_timer(0.5).timeout
		prepare_wave()
	

# Start theme song
func play_theme() -> void:
	main.get_node("Sounds").stream = load("res://%Project/Resources/Sounds/poland_theme_V2.mp3")
	main.get_node("Sounds").play()

## =============== [ SIGNALS ] ================ ##

# Start next wave
func _on_go_button_pressed() -> void:
	start_wave()
	main.get_node("MainUI/GoButton").hide()
