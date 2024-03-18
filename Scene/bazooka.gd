extends RigidBody2D

@onready var collision_operator = $ExplosionSize/CollisionPolygon2D
@onready var collision_detector = $ExplosionSize
var collider
@export var energy = 50
@export var damage = 45


func _physics_process(_delta):
	rotation = linear_velocity.angle()
	
func _on_area_2d_body_entered(body):
	collider = body
	if "clip" in collider.get_parent():
		collider.get_parent().clip(collision_operator)
	if "push_back" in collider:
		var center = self.global_position
		collider.push_back(center, energy, damage)
	explosion()

func _on_exploder_body_entered(_body):
	if body_entered:
		collision_detector.monitoring = true

func explosion():
	queue_free()


func _on_expiry_timeout():
	queue_free()
