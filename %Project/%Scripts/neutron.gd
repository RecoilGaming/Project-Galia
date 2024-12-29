extends CharacterBody2D
class_name Nuetron

var DAMAGE: int
var IS_ENEMY: bool
var SPEED: int = 10

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass

# Dies if out of bounds
func _process(_delta: float) -> void:
	if(global_position.x > 600 or global_position.x < -600 or global_position.y > 400 or global_position.y < -400):
		queue_free()


func _on_not_area_2d_body_entered(body: Node2D) -> void:
	if(is_valid_target(body)):
		body.take_damage(DAMAGE)
		queue_free()

func is_valid_target(unit: Node2D) -> bool:
	return unit is Unit and unit.IS_ENEMY != self.IS_ENEMY

# Moves the unit
func _physics_process(_delta: float) -> void:
	move_and_collide(velocity)
