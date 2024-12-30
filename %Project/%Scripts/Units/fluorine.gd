extends Hydrogen
class_name Fluorine

@export var DEATH_BULLET_SPAWN := 40

# Makes explosion boom spawning electrons and neutrons all around
func die():
	var neutron_path = "res://%Project/Characters/neutron.tscn"
	var electron_path = "res://%Project/Characters/electron.tscn"
	
	# Goes in a circle and alternates electrons and neutrons
	for i in range(0, DEATH_BULLET_SPAWN):
		if(i%2==0):
			do_exploding_attack(Vector2.UP.rotated(2*PI*i/DEATH_BULLET_SPAWN), neutron_path)
		else:
			do_exploding_attack(Vector2.UP.rotated(2*PI*i/DEATH_BULLET_SPAWN), electron_path)
	
	# Make exploision animation
	var explosion = load("res://%Project/Resources/Effects/explosion.tscn").instantiate()
	get_parent().add_child(explosion)
	explosion.global_position = global_position
	
	super.die()

# Shoots a bullet	
func do_exploding_attack(direction: Vector2, path: String):
	var bullet = load(path).instantiate()
	get_parent().add_child(bullet)
	
	# Moves it to 20 pixels in front
	bullet.global_position = global_position + 20 * (direction).normalized()
	bullet.is_enemy = self.is_enemy
	bullet.DAMAGE = DAMAGE
	bullet.velocity = direction.normalized() * bullet.SPEED
	
	if bullet is Electron:
		bullet.polarity = self.polarity

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
		unit_to_attack.take_damage(1)
		
		# If there's a collision it bounces it
		if collision:
			velocity = collision.get_collider_velocity().normalized() * KNOCKBACK
