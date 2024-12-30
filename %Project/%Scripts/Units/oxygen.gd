extends Unit
class_name Oxygen

@export var FOLLOWING_DISTANCE = 300
const FOLLOWING_MARGINS = 10
const BACKUP_SLOWDOWN = 0.2
var shot_cooldown: float = 1
var shooting := false
var bullet_path := "res://%Project/Characters/neutron.tscn"

# Moves the oxygen
func move(dir: Vector2, delta: float):
	
	# Distance to target
	var distance = global_position.distance_to(target.global_position)
		
	if(distance < FOLLOWING_DISTANCE - FOLLOWING_MARGINS):
		super.move(-dir, delta*BACKUP_SLOWDOWN)
		shooting = true
		
	elif(distance < FOLLOWING_DISTANCE):
		velocity = Vector2(0, 0)
		shooting = true
		
	elif(distance > (FOLLOWING_DISTANCE + FOLLOWING_MARGINS)):
		super.move(dir, delta)
		shooting = false
		
	if(!is_valid_target(target)):
		shooting = false

# Shoots a bullet	
func do_attack():
	var bullet = load(bullet_path).instantiate()
	get_parent().add_child(bullet)
	
	# Moves it to 20 pixels in front of the oxygen
	bullet.global_position = global_position + 20 * (target.global_position - global_position).normalized()
	bullet.is_enemy = self.is_enemy
	bullet.DAMAGE = DAMAGE
	bullet.velocity = (target.global_position - global_position).normalized() * bullet.SPEED
	
	# While oxygen never makes electrons, its child uranium does
	if bullet is Electron:
		bullet.polarity = self.polarity
