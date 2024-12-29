extends Hydrogen
class_name Fluorine

@export var DEATH_DAMAGE := 75
@export var ELECTRONS_SPAWN := 10
@export var SHOOT_DAMAGE := 10

func _ready() -> void:
	CONTACT_DAMAGE = 0

# Dyging
func die():
	for unit in bodies_to_attack:
		if(is_valid_target(unit)):
			unit.take_damage(DEATH_DAMAGE)
			
	for i in range(0, ELECTRONS_SPAWN):
		shoot(Vector2.UP.rotated(2*PI*i/ELECTRONS_SPAWN))
	
	GM.units.erase(self)
	GM.on_unit_death()
	queue_free()

# Shoots a bullet	
func shoot(direction: Vector2):
	var neutron = load("res://%Project/Characters/neutron.tscn").instantiate()
	get_parent().add_child(neutron)
	# Moves it to 20 pixels in front
	neutron.global_position = global_position + 20* (direction).normalized()
	neutron.IS_ENEMY = self.IS_ENEMY
	neutron.CONTACT_DAMAGE = SHOOT_DAMAGE
