extends Node2D

@onready var collision_operator = $aim/CollisionPolygon2D
var collider
var mouse_pos
var energy = 500
func _process(_delta):
	mouse_track()
	collision_operator_disabled()

func mouse_track():
	mouse_pos = get_global_mouse_position()
	$aim.global_position = mouse_pos
	
func collision_operator_disabled():
	if Input.is_action_pressed("boom"):
		collision_operator.set_deferred("disabled", false)
	elif Input.is_action_just_released("boom"):
		collision_operator.set_deferred("disabled", true)
	else :
		collision_operator.set_deferred("disabled", true)


func _on_aim_body_entered(body):
	collider = body
	if "clip" in collider.get_parent():
		collider.get_parent().clip(collision_operator)
	if "push_back" in collider:
		var center = mouse_pos

		var damage = 50
		collider.push_back(center, energy, damage)
