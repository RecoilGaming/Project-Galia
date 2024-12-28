extends CharacterBody2D
class_name Unit

## =============== [ FIELDS ] ================

# Attributes
@export var MAX_HEALTH: float = 100
@export var CONTACT_DAMAGE: float = 100
@export var SPEED: float = 100
@export var KNOCKBACK: float = 10
var health: float = 0
var polarity: int = 0

# Target unit
var target: Unit
var collision: KinematicCollision2D

## =============== [ METHODS ] ================

# Ready
func _ready() -> void:
	# Apply values
	health = MAX_HEALTH
	$Sprite.play(str(polarity))
	
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
		move(delta)
		
	# Deal collision CONTACT_DAMAGE
	if collision:
		velocity = collision.get_collider_velocity().normalized() * KNOCKBACK
		var collider: Unit = collision.get_collider()
		if collider:
			collider.deal_CONTACT_DAMAGE(CONTACT_DAMAGE)

# Physics process
func _physics_process(delta: float) -> void:
	collision = move_and_collide(velocity)

## =============== [ HELPERS ] ================

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

# Deal CONTACT_DAMAGE	
func deal_CONTACT_DAMAGE(val: int):
	health -= val
	
	# Dying
	if health <= 0:
		die()

# Dyging
func die():
	GM.units.erase(self)
	queue_free()

# Movint
func move(delta: float):
	var dir: Vector2 = target.global_position - global_position
	velocity = dir.normalized() * SPEED * delta
