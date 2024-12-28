extends Unit
class_name Nuetron

#@export var LIFESPAN = 2
#var alive_time = LIFESPAN

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	KNOCKBACK = 0
	$Sprite.play("default")

func set_polarity(value):
	var old_polarity = polarity
	
	polarity = clamp(value, Polarity.BIG_POSITIVE, Polarity.BIG_NEGATIVE)
	
	if(old_polarity == polarity):
		return false
	else:
		# Changes animation
		return true

func _process(delta: float) -> void:
	super(delta)
	if(target == null or target == self):
		die()


func _on_not_area_2d_body_entered(body: Node2D) -> void:
	if(body is Unit and body.IS_ENEMY != self.IS_ENEMY):
		body.take_damage(CONTACT_DAMAGE, polarity)
		die()
