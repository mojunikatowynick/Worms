extends RigidBody2D

@onready var collision_operator = $ExplosionSize/CollisionPolygon2D
@onready var collision_detector = $ExplosionSize
var collider
@export var energy = 300
@export var damage = 55
@onready var label = $Label
@onready var timer = $Timer
@onready var count_down: int = 3

func _ready():
	timer.start()
	label.text = "3"
	
func _physics_process(_delta):

	
	label.set_rotation(- self.rotation)
	
	$Polygon2D.rotation = linear_velocity.angle() * 2
	if count_down <= 0:
		collision_detector.monitoring = true

func _on_timer_timeout():
	count_down -= 1
	label.text = str(count_down)
	rotation = rotation / 3

func _on_explosion_size_body_entered(body):
	collider = body
	if "clip" in collider.get_parent():
		collider.get_parent().clip(collision_operator)
	if "push_back" in collider:
		var center = self.global_position
		collider.push_back(center, energy, damage)
	explosion()

func explosion():
	queue_free()
