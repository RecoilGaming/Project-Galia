extends Nuetron
class_name Electron


func _on_not_area_2d_body_entered(body: Node2D) -> void:
	if(is_valid_target(body)):
		body.polarity = self.polarity
		body.take_damage(CONTACT_DAMAGE)
		print("ELECTRIO DEALING " + str(CONTACT_DAMAGE))
		die()
