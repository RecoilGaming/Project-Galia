extends Node2D
class_name Unit

## =============== [ FIELDS ] ================

@onready var movemoent: Movement = $Movement

## =============== [ METHODS ] ================

func _ready() -> void:
	GM.add_unit(self)
