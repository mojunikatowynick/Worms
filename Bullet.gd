extends Node2D

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	var mouse_pos = get_global_mouse_position()
	$aim.global_position = mouse_pos

	if Input.is_action_just_pressed("boom"):
		pass
	

