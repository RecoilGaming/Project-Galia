extends Unit
class_name Hydrogen

var speed: float
const ACCELERATION = 2

# Units within melee range to attack melee
var units_to_attack: Array[Node2D]

# Connects Area2D stuff for attacking melee
func _ready() -> void:
	super()
	
	$NotArea2D.body_entered.connect(_body_entered)
	$NotArea2D.body_exited.connect(_body_exited)

# Does a melee attack and bounces everything back
func do_attack() -> void:
	validate_units()
	
	# Reset cooldown
	attack_cooldown = ATTACK_COOLDOWN
	
	if !units_to_attack.is_empty():
		
		# Picks random unit
		var unit_to_attack = units_to_attack.pick_random()
		
		var attack_animation: Sprite2D = load("res://%Project/Resources/Effects/attack.tscn").instantiate()
		attack_animation.rotation = (unit_to_attack.global_position - global_position).angle()
		attack_animation.position += Vector2(32, 0).rotated(attack_animation.rotation)
		add_child(attack_animation)
		
		# Deals damage to the unit equivilent to this unit's damage
		unit_to_attack.take_damage(self.DAMAGE)
		
		# If there's a collision it bounces it
		if collision:
			velocity = collision.get_collider_velocity().normalized() * KNOCKBACK

# Moving, can be overwritten to have different move behavior
func move(dir: Vector2, delta: float):
	if not target:
		velocity = Vector2.ZERO
	else:
		speed = lerp(speed, SPEED, ACCELERATION * delta)
		velocity = (target.global_position - self.global_position).normalized() * speed * delta

# Removes units that shouldn't be targetted anymore from the list of units to target
func validate_units():
	for unit in units_to_attack:
		if !is_valid_target(unit):
			units_to_attack.erase(unit)

# ------------- SIGNALS --------------

# Called on body entered
func _body_entered(body: Node2D):
	if (body is Unit and body != self):
		units_to_attack.append(body)

# Called on body exited
func _body_exited(body: Node2D):
	if body in units_to_attack:
		units_to_attack.erase(body)
