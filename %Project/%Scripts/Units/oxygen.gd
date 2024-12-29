extends Hydrogen
class_name Oxygen

@export var SHOOT_DAMAGE = 100
@export var FOLLOWING_DISTANCE = 300
@export var SHOT_COOLDOWN = 1
const FOLLOWING_MARGINS = 10
const BACKUP_SLOWDOWN = 0.2
var shot_cooldown: float = 1
var shooting := false

# Moves the oxygen
func move(dir: Vector2, delta: float):
	if(global_position.distance_to(target.global_position) < FOLLOWING_DISTANCE - FOLLOWING_MARGINS):
		super.move(-dir, delta*BACKUP_SLOWDOWN)
		shooting = true
	elif(global_position.distance_to(target.global_position) < FOLLOWING_DISTANCE):
		velocity = Vector2(0, 0)
		shooting = true
	elif(global_position.distance_to(target.global_position) > (FOLLOWING_DISTANCE + FOLLOWING_MARGINS)):
		super.move(dir, delta)
		shooting = false
	if(target == self):
		shooting = false

func _process(delta: float) -> void:
	super(delta)
	if(shooting):
		shot_cooldown -= delta
		if(shot_cooldown <= 0):
			shoot()
			shot_cooldown += SHOT_COOLDOWN

# Shoots a bullet	
func shoot():
	var neutron = load("res://%Project/Characters/neutron.tscn").instantiate()
	get_parent().add_child(neutron)
	# Moves it to 20 pixels in front
	neutron.global_position = global_position + 20* (target.global_position - global_position).normalized()
	neutron.IS_ENEMY = self.IS_ENEMY
	neutron.CONTACT_DAMAGE = SHOOT_DAMAGE
