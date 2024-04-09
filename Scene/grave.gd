extends CharacterBody2D
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")


func _physics_process(delta):

	#velocity.y += gravity * delta
	move_and_collide(Vector2(0, gravity*delta))
