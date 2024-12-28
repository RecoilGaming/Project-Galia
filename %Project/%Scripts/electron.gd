extends Unit
class_name Neutron

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
