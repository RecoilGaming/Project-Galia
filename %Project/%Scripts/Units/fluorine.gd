extends Unit
class_name Fluorine

# Spawns an equal amount of electrons and neutrons
@export var DEATH_BULLET_SPAWN := 20

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
	get_parent().add_child.call_deferred(explosion)
	explosion.global_position = global_position
	
	super.die()

# Shoots a bullet	
func do_exploding_attack(direction: Vector2, path: String):
	var bullet = load(path).instantiate()
	get_parent().add_child.call_deferred(bullet)
	
	# Moves it to 20 pixels in front
	bullet.global_position = global_position + 20 * (direction).normalized()
	bullet.IS_ENEMY = self.IS_ENEMY
	bullet.DAMAGE = DAMAGE
	bullet.velocity = direction.normalized() * bullet.SPEED
	
	if bullet is Electron:
		bullet.polarity = self.polarity
