extends Nuetron
class_name Electron

var polarity

func _on_not_area_2d_body_entered(body: Node2D) -> void:
	if(is_valid_target(body)):
		body.polarity = self.polarity
		body.take_damage(DAMAGE)
		queue_free()
