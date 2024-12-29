extends Oxygen
class_name Uranium

# Shoots a bullet	
func shoot():
	var electron = load("res://%Project/Characters/electron.tscn").instantiate()
	get_parent().add_child(electron)
	# Moves it to 20 pixels in front
	electron.global_position = global_position + 20* (target.global_position - global_position).normalized()
	electron.polarity = self.polarity
	electron.IS_ENEMY = self.IS_ENEMY
	electron.CONTACT_DAMAGE = SHOOT_DAMAGE
