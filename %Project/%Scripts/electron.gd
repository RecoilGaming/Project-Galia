extends Nuetron
class_name Electron

var polarity:
	set(value):
		value = clamp(value, -1, 1)
		if(value == -1 || value == 1):
			polarity = value
			$Sprite.play(str(polarity*2+2))

func _on_not_area_2d_body_entered(body: Node2D) -> void:
	if(is_valid_target(body)):
		body.polarity = self.polarity
		body.take_damage(DAMAGE)
		queue_free()
