extends Oxygen
class_name Uranium

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
	var electron = load("res://%Project/Characters/electron.tscn").instantiate()
	get_parent().add_child(electron)
	# Moves it to 20 pixels in front
	electron.global_position = global_position + 20* (target.global_position - global_position).normalized()
	electron.IS_ENEMY = self.IS_ENEMY
	electron.CONTACT_DAMAGE = SHOOT_DAMAGE
