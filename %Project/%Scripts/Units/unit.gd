extends CharacterBody2D
class_name Unit

## =============== [ FIELDS ] ================

# Attributes
@export var max_health: float = 100
@export var damage: float = 100
@export var speed: float = 100
@export var knockback: float = 10
var health: float = 0
var polarity: int = 0

# Target unit
var target: Unit
var collision: KinematicCollision2D

## =============== [ METHODS ] ================

# Ready
func _ready() -> void:
	# Apply values
	health = max_health
	$Sprite.play(str(polarity))
	
	# Add to global list
	GM.add_unit(self)

# Process
func _process(delta: float) -> void:
	# Find target
	find_target()
	
	# Track target
	if target:
		var dir: Vector2 = target.global_position - global_position
		velocity = dir.normalized() * speed * delta
		
	if collision:
		velocity = collision.get_collider_velocity().normalized() * knockback
		if collision.get_collider().is_class("Unit"):
			var collider: Unit = collision.get_collider()
			collider.deal_damage(damage)

# Physics process
func _physics_process(delta: float) -> void:
	collision = move_and_collide(velocity)

## =============== [ HELPERS ] ================

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

# Deal damage	
func deal_damage(amt: int):
	health -= amt
