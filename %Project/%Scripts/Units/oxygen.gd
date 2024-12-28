extends Hydrogen
class_name Oxygen

@export var SHOOT_DAMAGE = 0
@export var FOLLOWING_DISTANCE = 300
@export var SHOOT_COOLDOWN = 1
const FOLLOWING_MARGINS = 30
const BACKUP_SLOWDOWN = 0.2
var shot_cooldown: float = 1
var shooting := false

# Moves the oxygen
func move(dir: Vector2, delta: float):
	if(global_position.distance_to(target.global_position) < FOLLOWING_DISTANCE - FOLLOWING_MARGINS):
		super.move(-dir, delta*BACKUP_SLOWDOWN)
		shooting = true
		#print("backing up to " + str(-dir*BACKUP_SLOWDOWN))
	elif(global_position.distance_to(target.global_position) < FOLLOWING_DISTANCE):
		velocity = Vector2(0, 0)
		shooting = true
	elif(global_position.distance_to(target.global_position) > (FOLLOWING_DISTANCE + FOLLOWING_MARGINS)):
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
			shot_cooldown += SHOOT_COOLDOWN

# Shoots a bullet	
func shoot():
	var electron = load("res://%Project/Characters/neutron.tscn").instantiate()
	get_parent().add_child(electron)
	electron.global_position = global_position + 20* (target.global_position - global_position).normalized()
	electron.IS_ENEMY = self.IS_ENEMY
