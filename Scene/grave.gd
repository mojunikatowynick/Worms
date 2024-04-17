extends CharacterBody2D
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")
var water: bool = false

func _physics_process(delta):

	if water:
			move_and_collide(Vector2(0, gravity/4*delta))
	else:
		move_and_collide(Vector2(0, gravity*delta))

func grave_in_water():
	self.call_deferred("set_collision_mask_value", 1, false)
	water = true
