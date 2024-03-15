extends Area2D

var direction: Vector2 = Vector2.UP
var energy 


func _ready():
	pass # Replace with function body.

func _physics_process(delta):
	
	position += direction * energy * delta
	
