extends State
class_name  Active

@export var player: CharacterBody2D
@onready var AP = $"../../Animations/AnimationPlayer"
@onready var sniper_ray = $"../../Polygon2D/center/SniperRay"
var sniper_ammo = 2

func Enter():
	$"../../Polygon2D/center/CrossHairSprite".visible = true

	
func Physics_update(delta: float):
	movement(delta)
	weapon_handler()
	Global.camera_pos = player.position
	if player.active == false:
		Transitioned.emit(self, "Innactive")

func movement(_delta):
	var direction = Input.get_axis("left","right")
	player.velocity.x = direction * player.move_speed
	
	if Input.is_action_pressed("up") and player.center_point.rotation_degrees >= -90:
		player.center_point.rotation_degrees -= 2
	elif Input.is_action_pressed("down") and player.center_point.rotation_degrees <= 90:
		player.center_point.rotation_degrees += 2
		
	if Input.is_action_just_pressed("jump") and player.is_on_floor():
		player.velocity.y = player.jump_speed
	
func weapon_handler():
	if Global.weapon_chosen == "bazooka" or Global.weapon_chosen == "granade":
		if Input.is_action_just_pressed("fire"):
				AP.play("Power")
				player.weapon_active = true
				player.timer_weapon_energy.start()
		if Input.is_action_just_released("fire") and player.weapon_active or player.weapon_energy >= 80000:
			fire()
	if Global.weapon_chosen == "sniper":
		if Input.is_action_just_pressed("fire"):
			fire_sniper()

func fire():
	AP.stop()
	$"../../Polygon2D/center/PowerInd".visible = false
	player.weapon_active = false
	var direction = (player.cross_hair.global_position - player.weapon_spawn.global_position).normalized()
	var pos = player.weapon_spawn.global_position
	var energy = player.weapon_energy 
	player.weapon_shot.emit(pos, direction, energy)
	player.timer_weapon_energy.stop()
	player.weapon_energy = 10000

func fire_sniper():
	var collision_point 
	if sniper_ray.is_colliding():
		collision_point = sniper_ray.get_collision_point()
	else:
		collision_point = null
	player.weapon_shot_sniper.emit(collision_point)

func _on_fire_power_timeout():
	player.weapon_energy += 12500

