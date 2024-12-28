extends Hydrogen
class_name Oxygen

@export var SHOOT_DAMAGE = 0
@export var FOLLOWING_DISTANCE = 300
@export var SHOOT_COOLDOWN = 1
const FOLLOWING_MARGINS = 30
const BACKUP_SLOWDOWN = 0.2
var shot_cooldown: float = 1

# Moves the oxygen
func move(dir: Vector2, delta: float):
	if(global_position.distance_to(target.global_position) < FOLLOWING_DISTANCE - FOLLOWING_MARGINS):
		super.move(-dir, delta*BACKUP_SLOWDOWN)
		#print("backing up to " + str(-dir*BACKUP_SLOWDOWN))
	elif(global_position.distance_to(target.global_position) < FOLLOWING_DISTANCE):
		velocity = Vector2(0, 0)
	elif(global_position.distance_to(target.global_position) > (FOLLOWING_DISTANCE + FOLLOWING_MARGINS)):
		super.move(dir, delta)
		#print("moving up to " + str(dir))

func _process(delta: float) -> void:
	super(delta)
	shot_cooldown -= delta
	if(shot_cooldown <= 0):
		shoot()
		shot_cooldown += SHOOT_COOLDOWN

# Shoots a bullet	
func shoot():
	var electron = load("res://%Project/Characters/electron.tscn").instantiate()
	get_parent().add_child(electron)
	electron.global_position = global_position
	electron.IS_ENEMY = self.IS_ENEMY
