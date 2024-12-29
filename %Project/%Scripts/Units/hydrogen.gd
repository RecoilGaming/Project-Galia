extends Unit
class_name Hydrogen

func do_attacks() -> void:
	if attack_cooldown <= 0:
		attack_cooldown = ATTACK_COOLDOWN
		
		if !bodies_to_attack.is_empty():
			var not_null = bodies_to_attack.pick_random()
			
			if is_valid_target(not_null):
				var fancy_thing: Sprite2D = load("res://%Project/Resources/Effects/attack.tscn").instantiate()
				fancy_thing.rotation = (not_null.global_position - global_position).angle()
				fancy_thing.position += Vector2(32, 0).rotated(fancy_thing.rotation)
				add_child(fancy_thing)
				
				not_null.take_damage(CONTACT_DAMAGE)
	update_healthbar()
