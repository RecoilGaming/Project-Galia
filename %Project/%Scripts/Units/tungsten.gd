extends Hydrogen
class_name Tungsten

@export var FLAT_ARMOR := 10
@export var FRACTIONAL_ARMOR := 0.5

# Deal physical damage
func take_damage(amt: int): # Amount of damage, Damage component polarity
	
	amt = amt-FLAT_ARMOR
	amt *= FRACTIONAL_ARMOR
	
	health -= clamp(amt, 1, 1000000000)
	
	# Dying
	if health <= 0:
		die()
