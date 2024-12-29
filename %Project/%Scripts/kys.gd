extends Node2D

@export var life = 0.1

func _process(delta: float) -> void:
	life -= delta
	if life <= 0:
		queue_free()
