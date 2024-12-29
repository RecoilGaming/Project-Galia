extends Hydrogen
class_name Oxygen

@export var SHOOT_DAMAGE = 100
@export var NEGATIVE_FOLLOWING_DISTANCE = 300
@export var POSITIVE_FOLLOWING_DISTANCE = 80
@export var NEGATIVE_SHOOT_COOLDOWN = 1
@export var POSITIVE_SHOOT_COOLDOWN = 0.2
const FOLLOWING_MARGINS = 10
const BACKUP_SLOWDOWN = 0.2
var shot_cooldown: float = 1
var shooting := false

# Moves the oxygen
func move(dir: Vector2, delta: float):
	if(polarity > Polarity.NEUTRAL):
		if(global_position.distance_to(target.global_position) < NEGATIVE_FOLLOWING_DISTANCE - FOLLOWING_MARGINS):
			super.move(-dir, delta*BACKUP_SLOWDOWN)
			shooting = true
			#print("backing up to " + str(-dir*BACKUP_SLOWDOWN))
		elif(global_position.distance_to(target.global_position) < NEGATIVE_FOLLOWING_DISTANCE):
			velocity = Vector2(0, 0)
			shooting = true
		elif(global_position.distance_to(target.global_position) > (NEGATIVE_FOLLOWING_DISTANCE + FOLLOWING_MARGINS)):
			super.move(dir, delta)
			shooting = false
			#print("moving up to " + str(dir))
		if(target == self):
			shooting = false
	elif(polarity < Polarity.NEUTRAL):
		if(global_position.distance_to(target.global_position) < POSITIVE_FOLLOWING_DISTANCE - FOLLOWING_MARGINS):
			super.move(-dir, delta*BACKUP_SLOWDOWN)
			shooting = true
			#print("backing up to " + str(-dir*BACKUP_SLOWDOWN))
		elif(global_position.distance_to(target.global_position) < POSITIVE_FOLLOWING_DISTANCE):
			velocity = Vector2(0, 0)
			shooting = true
		elif(global_position.distance_to(target.global_position) > (POSITIVE_FOLLOWING_DISTANCE + FOLLOWING_MARGINS)):
			super.move(dir, delta)
			shooting = false
			#print("moving up to " + str(dir))
		if(target == self):
			shooting = false

func _process(delta: float) -> void:
	super(delta)
	if(shooting):
		shot_cooldown -= delta
		if(shot_cooldown <= 0):
			shoot()
			if(polarity > Polarity.NEUTRAL):
				shot_cooldown += NEGATIVE_SHOOT_COOLDOWN
			elif(polarity < Polarity.NEUTRAL):
				shot_cooldown += POSITIVE_SHOOT_COOLDOWN

# Shoots a bullet	
func shoot():
	var neutron = load("res://%Project/Characters/neutron.tscn").instantiate()
	get_parent().add_child(neutron)
	neutron.global_position = global_position + 20* (target.global_position - global_position).normalized()
	neutron.IS_ENEMY = self.IS_ENEMY
	neutron.CONTACT_DAMAGE = SHOOT_DAMAGE
