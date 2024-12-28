extends Hydrogen
class_name Oxygen

@export var SHOOT_DAMAGE = 0
@export var FOLLOWING_DISTANCE = 300
const FOLLOWING_MARGINS = 30
const BACKUP_SLOWDOWN = 0.2

func move(dir: Vector2, delta: float):
	if(global_position.distance_to(target.global_position) < FOLLOWING_DISTANCE - FOLLOWING_MARGINS):
		super.move(-dir, delta*BACKUP_SLOWDOWN)
		print("backing up to " + str(-dir*BACKUP_SLOWDOWN))
	elif(global_position.distance_to(target.global_position) < FOLLOWING_DISTANCE):
		velocity = Vector2(0, 0)
	elif(global_position.distance_to(target.global_position) > (FOLLOWING_DISTANCE + FOLLOWING_MARGINS)):
		super.move(dir, delta)
		print("moving up to " + str(dir))
