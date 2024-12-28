extends CharacterBody2D
class_name Unit

## =============== [ FIELDS ] ================ ##

# Attributes
@export var MAX_HEALTH: float = 100
@export var CONTACT_DAMAGE: float = 2
@export var SPEED: float = 100
@export var KNOCKBACK: float = 10
@export var IS_ENEMY: bool = false
@export var ATTACK_COOLDOWN: float = 0.1

var health: float = MAX_HEALTH
var attack_cooldown := ATTACK_COOLDOWN

enum Polarity { BIG_POSITIVE, POSITIVE, NEUTRAL, NEGATIVE, BIG_NEGATIVE }

@export var polarity: Polarity = Polarity.NEUTRAL:
	set(value):
		polarity = clamp(value, Polarity.BIG_POSITIVE, Polarity.BIG_NEGATIVE)

# Target unit
var target: Unit
var collision: KinematicCollision2D
var bodies_to_attack: Array[Node2D]

## =============== [ METHODS ] ================ ##

# Ready
func _ready() -> void:
	# Apply values
	$Sprite.play(str(polarity))
	self.input_event.connect(_on_input_event)
	IS_ENEMY = randi_range(0, 1)
	polarity = randi_range(0, 4)
	# Add to global list
	GM.add_unit(self)
	
	$NotArea2D.body_entered.connect(_body_entered)
	$NotArea2D.body_exited.connect(_body_exited)

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
	
	attack_cooldown -= delta
	if(attack_cooldown <= 0):
		attack_cooldown = ATTACK_COOLDOWN
		
		if(!bodies_to_attack.is_empty()):
			var not_null = bodies_to_attack.pick_random()
			
			if(not_null):
				not_null.take_damage(CONTACT_DAMAGE, polarity)
				
				## Collides the thing
				#if collision:
					#velocity = collision.get_collider_velocity().normalized() * KNOCKBACK

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
		if unit != self and dist < min_dist and unit.IS_ENEMY != self.IS_ENEMY:
			min_dist = dist
			target = unit

# Deal physical damage
func take_damage(amt: int, dc_polarity: Polarity): # Amount of damage, Damage component polarity
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
	
	$Sprite.play(str(polarity))
	return true

## =============== [ SIGNALS ] ================ ##

# Left click detection
func _on_input_event(viewport: Node, event: InputEvent, shape_idx: int) -> void:
	if event.is_pressed() and GM.polarizing:
		if event.button_index == MOUSE_BUTTON_LEFT:
			change_polarity(-1)
		elif event.button_index == MOUSE_BUTTON_RIGHT:
			change_polarity(1)

func _body_entered(body: Node2D):
	if(body is Unit and body != self):
		bodies_to_attack.append(body)

func _body_exited(body: Node2D):
	bodies_to_attack.erase(body)
