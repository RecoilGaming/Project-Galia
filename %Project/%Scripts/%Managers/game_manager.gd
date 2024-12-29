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
var unit_spawn_index: int = 0
var types = {
	{0 = "hydrogen"}
	{1 = "oxygen"}
	{2 = "fluorine"}
	{3 = "tungsten"} 
	{4 = "uranium"}
}
var polarizing_window_open: bool = false
var adding_window_open: bool = false

var current_wave := 0
var waves := [
	[["hydrogen", 3]],
	[["hydrogen", 3], ["oxygen", 2]],
	[["hydrogen", 5], ["oxygen", 4]],
	[["hydrogen", 3], ["oxygen", 2], ["fluorine", 2]],
	[["hydrogen", 0], ["oxygen", 5], ["fluorine", 0], ["tungsten", 2]],
	[["hydrogen", 0], ["oxygen", 0], ["fluorine", 0], ["uranium", 10]],
	[["hydrogen", 5], ["oxygen", 5], ["fluorine", 5], ["tungsten", 5], ["uranium", 5]],
	[["hydrogen", 30], ["oxygen", 20], ["fluorine", 0], ["tungsten", 0], ["uranium", 0]],
]

var UNIT_COSTS = {
	"hydrogen" = 5,
	"oxygen" = 15,
	"fluorine" = 10,
	"tungsten" = 20,
	"uranium" = 15,
}

func _ready():
	update_coins()
	var menu: Control = load("res://%Project/%Levels/menu.tscn").instantiate()
	main.add_child.call_deferred(menu)

## =============== [ METHODS ] ================

# Add unit
func add_unit(unit: Unit):
	units.append(unit)

# Spawn unit with subtract coins
func spawn_unit(pos: Vector2, index: int):
	if coins >= UNIT_COSTS[types[index]]:
		if(try_to_spawn(types[index], pos, false)): # Spawns an ally
			# Subtract cost
			coins -= UNIT_COSTS[types[index]]
			print("subtracted " + str(UNIT_COSTS[types[index]]) + " coins")

func update_coins():
	main.get_node("MainUI/CoinText").text = "Yer got " + str(coins) + " cainz"

func can_spawn(pos: Vector2) -> bool:
	for unit in units:
		var distance = unit.global_position.distance_to(pos)
		if(distance < 30):
			return false
	return true

# Attempts to spawn WITHOUT coins, checks for valid location
func try_to_spawn(u: String, pos: Vector2, enemy: bool) -> bool:

	# Instantiate unit
	var unit: Unit = load("res://%Project/Characters/" + u + ".tscn").instantiate()
	unit.position = pos
	unit.polarity = randi_range(0, 1)*2-1
	unit.IS_ENEMY = enemy
	# Add child
	main.add_child.call_deferred(unit)	
	return true

func new_wave():
	Engine.set_time_scale(0.5)
	
	var wave_to_spawn = waves[current_wave]
	
	for spawn in wave_to_spawn:
		var unit_class = spawn[0]
		var i := 0
		#print(spawn[1])
		while i < spawn[1]:
			if(try_to_spawn(unit_class, Vector2(randi_range(30, 290), randi_range(-150, 150)), true)): # -320, -180 to 320, 180 is the canvas
				i += 1
				#print("UNIT SPAWNED")
	current_wave += 1


func _on_go_button_pressed() -> void:
	new_wave()
	main.get_node("MainUI/GoButton").hide()
	
func on_unit_death() -> void:
	# search for remaining enemies
	for unit in units:
		if unit.IS_ENEMY:
			return
	main.get_node("MainUI/GoButton").show()

func play_theme() -> void:
	main.get_node("Sounds").stream = load("res://%Project/Resources/Sounds/poland_theme.mp3")
	main.get_node("Sounds").play()
