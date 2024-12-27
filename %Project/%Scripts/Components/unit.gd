extends CharacterBody2D
class_name Unit

## =============== [ FIELDS ] ================

# Components
@onready var sprite: AnimatedSprite2D = $Sprite
@onready var collider: CircleShape2D = $Collider.shape

# Colliding
@export var collision_strength = 20

# Data
@export var data: UnitData
var polarity: int = 0
var health: int = 0

# Target unit
var target: Unit
var collision: KinematicCollision2D

## =============== [ METHODS ] ================

# Ready
func _ready() -> void:
	# Initialize data
	if data:
		init()

# Process
func _process(delta: float) -> void:
	# Find target
	find_target()
	
	# Track target
	if target:
		var dir: Vector2 = target.global_position - global_position
		velocity = dir.normalized() * data.speed * delta
		
	if collision:
		velocity = Vector2.UP.rotated(collision.get_angle()) * collision_strength

# Physics process
func _physics_process(delta: float) -> void:
	collision = move_and_collide(velocity)

## =============== [ HELPERS ] ================

# Initialize
func init() -> void:
	# Apply data
	sprite.sprite_frames = data.sprite
	collider.radius = data.radius
	
	sprite.play(str(polarity))
	health = data.max_health
	
	# Add to global list
	GM.add_unit(self)
	

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
