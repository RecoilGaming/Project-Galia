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

@export var polarity: int = 0:
	set(value):
		if(value == -1 || value == 1):
			polarity = value
			$Sprite.play(str(polarity*2+2))

# Target unit
var target: Unit
var collision: KinematicCollision2D
var bodies_to_attack: Array[Node2D]

## =============== [ METHODS ] ================ ##

# Ready
func _ready() -> void:
	# Apply values
	self.input_event.connect(_on_input_event)
	polarity = polarity
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
			
			if(is_valid_target(not_null)):
				not_null.take_damage(CONTACT_DAMAGE)
				
				## Collides the thing
				#if collision:
					#velocity = collision.get_collider_velocity().normalized() * KNOCKBACK
	update_healthbar()

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
		if dist < min_dist and is_valid_target(unit):
			min_dist = dist
			target = unit

# Deal physical damage
func take_damage(amt: int): # Amount of damage, Damage component polarity
	
	health -= amt
	
	# Dying
	if health <= 0:
		die()

# Dyging
func die():
	GM.units.erase(self)
	GM.on_unit_death()
	queue_free()

# Movint
func move(dir: Vector2, delta: float):
	velocity = dir.normalized() * SPEED * delta

# Change polarity, returns whether it was successful
func change_polarity(amt: int) -> bool:
	var temp = polarity
	polarity += amt
	return temp != polarity

func is_valid_target(unit: Node2D) -> bool:
	return unit is Unit and unit != self and unit.IS_ENEMY != self.IS_ENEMY and unit.polarity != self.polarity

## =============== [ SIGNALS ] ================ ##

# Left click detection
func _on_input_event(_viewport: Node, event: InputEvent, _shape_idx: int) -> void:
	if event.is_pressed() and GM.polarizing_window_open:
		if event.button_index == MOUSE_BUTTON_LEFT:
			change_polarity(-2)
		elif event.button_index == MOUSE_BUTTON_RIGHT:
			change_polarity(2)

func _body_entered(body: Node2D):
	if (body is Unit and body != self):
		bodies_to_attack.append(body)

func _body_exited(body: Node2D):
	bodies_to_attack.erase(body)

func update_healthbar():
	if has_node("HealthBar"):
		$HealthBar.value = health/MAX_HEALTH
