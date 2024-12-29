extends Unit
class_name Nuetron


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	KNOCKBACK = 0
	$Sprite.play("default")

func _process(delta: float) -> void:
	super(delta)
	print("DEALING " + str(CONTACT_DAMAGE))
	if(target == null or target == self):
		die()


func _on_not_area_2d_body_entered(body: Node2D) -> void:
	if(body is Unit and is_valid_target(body)):
		body.take_damage(CONTACT_DAMAGE)
		print("DEALING " + str(CONTACT_DAMAGE))
		die()
