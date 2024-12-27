extends CharacterBody2D
class_name Unit

## =============== [ FIELDS ] ================

# Attributes
@export var speed: float = 100
@export var health: int = 100
@export var unit_faction: FACTION
@export var collision_strength = 20
enum FACTION {NEGATIVE, POSITIVE}

# Target unit
var target: Unit
var collision: KinematicCollision2D

## =============== [ METHODS ] ================

# Ready
func _ready() -> void:
	GM.add_unit(self)

# Process
func _process(delta: float) -> void:
	# Find target
	find_target()
	
	# Track target
	if target:
		var dir: Vector2 = target.global_position - global_position
		velocity = dir.normalized() * speed * delta
		
	# Bounces back hydrogen on collision
	if(collision):
		velocity = collision.get_collider_velocity()
		

# Physics process
func _physics_process(delta: float) -> void:
	collision = move_and_collide(velocity)

## =============== [ HELPERs ] ================

# Finds the nearest target
func find_target() -> void:
	# Minimum distance
	var min_dist: float = 1000000
	
	# Loop through units
	for unit in GM.units:
		# Get distance
		var dist: float = global_position.distance_to(unit.global_position)
		
		# Check unit
		if unit != self and dist < min_dist:
			min_dist = dist
			target = unit
