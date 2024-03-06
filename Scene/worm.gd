extends CharacterBody2D

var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")
@export var jump_speed: int = -350
@export var move_speed: int = 100

func _physics_process(delta):
	
	sprite_scalling()
	move_and_slide()
	movement(delta)

func sprite_scalling():
	if velocity.x > 0:
		$Polygon2D.scale.x = 1
	elif velocity.x < 0:
		$Polygon2D.scale.x = -1

func movement(delta):
	velocity.y += gravity * delta
	var direction = Input.get_axis("left","right")
	velocity.x = direction * move_speed
	
	if Input.is_action_just_pressed("jump") and is_on_floor():
		velocity.y = jump_speed
