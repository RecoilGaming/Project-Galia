extends Unit



# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	KNOCKBACK = 0
	$Sprite.play("default")


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
