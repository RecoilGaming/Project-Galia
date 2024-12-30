extends CharacterBody2D
class_name Unit

## =============== [ FIELDS ] ================ ##

# Attributes
# Max health of the unit
@export var MAX_HEALTH: float = 100
# Damage of the unit, both ranged and melee
@export var DAMAGE: float = 10
# Speed of the unit
@export var SPEED: float = 100
# KB of the unit, maybe temporary
@export var KNOCKBACK: float = 10
# Every ATTACK_COOLDOWN+(~0.010) seconds, do_attack() is called
@export var ATTACK_COOLDOWN: float = 0.1

@export var INDEX: int = 0 # todo

# Whether the unit is an enemy unit
var IS_ENEMY: bool = false

var health: float = MAX_HEALTH:
	set(value):
		health = value
		update_healthbar()
var attack_cooldown := ATTACK_COOLDOWN

# Polarity: -1 for negative, 1 for positive
@export var polarity: int = 0:
	set(value):
		value = clamp(value, -1, 1)
		if(value == -1 || value == 1):
			polarity = value
			$Sprite.play(str(polarity*2+2))

# The unit that will be followed and shot at and attacked
var target: Unit

# Collision upon MOVING FORWARD
var collision: KinematicCollision2D

## =============== [ METHODS ] ================ ##

# Gets called hopefuly once
func _ready() -> void:
	
	# Add this to global list of units
	GM.units.append(self)
	
	# Connects signals
	self.input_event.connect(_on_input_event)
	
	
	# Sets the health bar to be purple if enemy otherwise green
	if (has_node("HealthBar")):
		$HealthBar.theme = load("res://%Project/Resources/" + ("purple" if IS_ENEMY else "green") + "1.tres")
	else:
		print("no health bar found")
	update_healthbar()

# Being called every frame
func _process(delta: float) -> void:
	
	# Finds the nearest target
	find_target()
	
	# If the target died aka it's invalid, it will be self
	# This is useful in the move function to stop moving
	if !is_instance_valid(target):
		target = self
	
	# Tracks the target, moves and then attacks
	if target:
		
		# Even if the target is self, we should call this to update velocity
		move(target.global_position - global_position, delta)
		
		# However attacks should only be called if the target is not self
		if is_valid_target(target):
			
			# Executes an attack every ATTACK_COOLDOWN seconds
			attack_cooldown -= delta
			if(attack_cooldown <= 0):
				do_attack()
				attack_cooldown = ATTACK_COOLDOWN

# Moves the unit
func _physics_process(_delta: float) -> void:
	collision = move_and_collide(velocity)

# Does an attack, overwrite for different attack behavior
func do_attack() -> void:
	pass

## =============== [ HELPERS ] ================ ##

# Finds the nearest target
func find_target() -> void:
	var min_dist: float = 1000000
	
	# This is so that target doesn't switch mid-function
	var temp_target
	
	# Loop through all units
	for unit in GM.units:
		
		# Get distance
		var dist: float = global_position.distance_to(unit.global_position)
		
		# Check whether this is the closest unit and is valid
		if dist < min_dist and is_valid_target(unit):
			min_dist = dist
			temp_target = unit
			
	target = temp_target

# Call this to deal physical damage to the unit, automatically dies and updates healthbar
func take_damage(amt: int):
	
	# This will internally update healthbar
	health -= amt
	
	# Dying
	if health <= 0:
		die()

# Called when you want to delete this unit, 
func die():
	GM.units.erase(self)
	GM.clean_wave()
	queue_free()

# Moving, can be overwritten to have different move behavior
func move(dir: Vector2, delta: float):
	if not target:
		velocity = Vector2.ZERO
	else:
		velocity = dir.normalized() * SPEED * delta

# Checks whether the target is valid, overwrite to change what should be targetted and attacked
func is_valid_target(unit: Node2D) -> bool:
	return unit is Unit and unit != self and unit.IS_ENEMY != self.IS_ENEMY and unit.polarity != self.polarity

## =============== [ SIGNALS ] ================ ##

# Left click detection to change polarity
func _on_input_event(_viewport: Node, event: InputEvent, _shape_idx: int) -> void:
	if event.is_pressed() and !IS_ENEMY:
		if GM.is_polarizing:
			polarity = -polarity;
		if GM.is_selling:
			GM.coins += GM.unit_price[INDEX]
			die()

# Updates healthbar
func update_healthbar():
	if has_node("HealthBar"):
		$HealthBar.value = health/MAX_HEALTH
