extends Unit
class_name Nuetron


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	KNOCKBACK = 0
	polarity = polarity

func _process(delta: float) -> void:
	super(delta)
	if(target == null or target == self):
		die()


func _on_not_area_2d_body_entered(body: Node2D) -> void:
	if(is_valid_target(body)):
		body.take_damage(CONTACT_DAMAGE)
		print("NEUTRON DEALING " + str(CONTACT_DAMAGE))
		die()

func is_valid_target(unit: Node2D) -> bool:
	return unit is Unit and unit != self and unit.IS_ENEMY != self.IS_ENEMY
