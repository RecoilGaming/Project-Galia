extends Hydrogen
class_name Tungsten

@export var FLAT_ARMOR := 10
@export var FRACTIONAL_ARMOR := 0.5

# Deal physical damage
func take_damage(amt: int): # Amount of damage, Damage component polarity
	
	amt = clamp(amt-FLAT_ARMOR, 1, amt)
	amt *= FRACTIONAL_ARMOR
	
	health -= amt
	
	# Dying
	if health <= 0:
		die()
