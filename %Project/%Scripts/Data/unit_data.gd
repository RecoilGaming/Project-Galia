extends Resource
class_name UnitData

## =============== [ FIELDS ] ================

# General
@export var sprite: SpriteFrames
@export var name: String
@export var cost: int

# Collision
@export var radius: int

# Attributes
@export var max_health: float = 100
@export var damage: float = 100
@export var speed: float = 100
