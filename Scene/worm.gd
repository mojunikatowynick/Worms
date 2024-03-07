extends CharacterBody2D

var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")
@export var jump_speed: int = -350
@export var move_speed: int = 100
var active: bool = false
var hp = 100
@onready var center_point = $Polygon2D/center

func _physics_process(delta):
	
	sprite_scalling()
	move_and_slide()
	movement(delta)
	
	if hp <= 0:
		queue_free()

func sprite_scalling():
	if velocity.x > 0:
		$Polygon2D.scale.x = 1
	elif velocity.x < 0:
		$Polygon2D.scale.x = -1

func movement(delta):
	
	velocity.y += gravity * delta
	
	if active:
		var direction = Input.get_axis("left","right")
		velocity.x = direction * move_speed
		
		if Input.is_action_pressed("up") and center_point.rotation_degrees >= -90:
			center_point.rotation_degrees -= 5
		elif Input.is_action_pressed("down") and center_point.rotation_degrees <= 90:
			center_point.rotation_degrees += 5
			
		if Input.is_action_just_pressed("jump") and is_on_floor():
			velocity.y = jump_speed
	else:
		if velocity.x > 50 and is_on_floor():
			velocity.x = velocity.x - 10
			if velocity.x < 50:
				velocity.x = 0
		elif velocity.x < -50 and is_on_floor():
			velocity.x = velocity.x + 10
			if velocity.x > -50:
				velocity.x = 0
				
		
		

func push_back(center, energy, damage):
		var fly_dir = center_point.global_position - center
		velocity = fly_dir.normalized() * energy
		hp -= damage



func _on_button_toggled(toggled_on):
	if toggled_on:
		active = true
	else:
		active = false
	print(active)

