extends CharacterBody2D
class_name Unit

## =============== [ FIELDS ] ================ ##

# Attributes
@export var MAX_HEALTH: float = 100
@export var CONTACT_DAMAGE: float = 2
@export var SPEED: float = 100
@export var KNOCKBACK: float = 10
var health: float = 0

enum POLARITY {BIG_POSITIVE, POSITIVE, NEUTRAL, NEGATIVE, BIG_NEGATIVE}

@export var polarity: POLARITY = POLARITY.NEUTRAL:
	set(value):
		polarity = clamp(value, POLARITY.BIG_POSITIVE, POLARITY.BIG_NEGATIVE)
		# Changes animation
		$Sprite.play(str(polarity))

# Target unit
var target: Unit
var collision: KinematicCollision2D

## =============== [ METHODS ] ================ ##

# Ready
func _ready() -> void:
	# Apply values
	health = MAX_HEALTH
	$Sprite.play(str(polarity))
	self.input_event.connect(_on_input_event)
	
	# Add to global list
	GM.add_unit(self)

# Process
func _process(delta: float) -> void:
	# Find target
	find_target()
	
	# No targets
	if !is_instance_valid(target):
		target = self
	
	# Track target
	if target:
		move(target.global_position - global_position, delta)
		
	# Deal collision CONTACT_DAMAGE
	if collision:
		velocity = collision.get_collider_velocity().normalized() * KNOCKBACK
		var collider: Unit = collision.get_collider()
		if collider:
			collider.take_damage(CONTACT_DAMAGE, self.polarity)

# Physics process
func _physics_process(delta: float) -> void:
	collision = move_and_collide(velocity)

## =============== [ HELPERS ] ================ ##

# Finds the nearest target
func find_target() -> void:
	# Minimum distance
	var min_dist: float = 1000000
	
	# Loop through edits
	for unit in GM.units:
		# Get distance
		var dist: float = global_position.distance_to(unit.global_position)
		
		# Check unit
		if unit != self and dist < min_dist:
			min_dist = dist
			target = unit

# Deal physical damage
func take_damage(amt: int, dc_polarity: POLARITY): # Amount of damage, Damage component polarity
	# FLOWCHART TIME!!!
	# If they're the same, this is 1
	# If they're the different by 1, this is 2
	# If they're the different by 2, this is 5
	# If they're the different by 3, this is 10
	# If they're the different by 4, this is 17
	# Note: Make base damage take this into account i.e. have it be small
	var damage_multiplier = abs(dc_polarity-self.polarity)
	damage_multiplier *= damage_multiplier
	damage_multiplier += 1
	health -= amt*damage_multiplier
	#print("I, "+ str(self.name) +" have " + str(health) + "hp and are taking " + str(damage_multiplier))
	
	# Dying
	if health <= 0:
		die()

# Dyging
func die():
	GM.units.erase(self)
	queue_free()

# Movint
func move(dir: Vector2, delta: float):
	#acceleration = dir.normalized() * SPEED * delta
	velocity = dir.normalized() * SPEED * delta

# Change polarity, returns whether it was successful
func change_polarity(amt: int) -> bool:
	var old_polarity = polarity
	polarity += amt
	
	# If the polarity didn't change
	if(polarity == old_polarity):
		return false
	
	return true

## =============== [ SIGNALS ] ================ ##

# Left click detection
func _on_input_event(viewport: Node, event: InputEvent, shape_idx: int) -> void:
	if event.is_pressed() and event.button_index == MOUSE_BUTTON_LEFT:
		change_polarity(GM.click_polarity)
