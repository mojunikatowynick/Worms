extends State
class_name  Active

@export var player: CharacterBody2D
@export_range(0.2, 1.0, 0.1) var zoom_camera
@onready var AP = $"../../Animations/AnimationPlayer"
@onready var sniper_ray = $"../../Polygon2D/center/SniperRay"
var pre_wait: bool = false

func Enter():
	pre_wait = false
	Global.weapon_chosen = "null"
	await get_tree().create_timer(2).timeout
	pre_wait = true
	$"../../Polygon2D/center/CrossHairSprite".visible = true
	player.weapon_active = true
	zoom_camera = 0.7
	
func Physics_update(delta: float):
	
	var tween = get_tree().create_tween()
	tween.set_parallel(true)
	tween.tween_property(player.get_parent().get_parent().player_camera, "zoom", Vector2(zoom_camera, zoom_camera), 1)
	tween.tween_property(player.get_parent().get_parent().player_camera, "position", player.position, 1)
	if pre_wait:
		if player.is_on_floor():
			movement(delta)
			if player.weapon_active:
				weapon_handler()
			else:
				pass
			if player.active == false:
				Transitioned.emit(self, "Innactive")
		else:
			pass
	else:
		pass
		
	if not player.active:
		weapon_dissapear()


func movement(_delta):
	var direction = Input.get_axis("left","right")
	player.velocity.x = direction * player.move_speed
	
	if Input.is_action_pressed("up") and player.center_point.rotation_degrees >= -90:
		player.center_point.rotation_degrees -= 1
	elif Input.is_action_pressed("down") and player.center_point.rotation_degrees <= 90:
		player.center_point.rotation_degrees += 1
	if Input.is_action_just_pressed("jump") and player.is_on_floor():
			player.velocity.y = player.jump_speed
			if player.sprite_worm.scale.x == -1:
				player.velocity.x = player.jump_speed/3
			elif player.sprite_worm.scale.x == 1:
				player.velocity.x = -player.jump_speed/3
	if Input.is_action_just_pressed("zoomin") and zoom_camera <= 1:
		self.zoom_camera += 0.05
	if Input.is_action_just_pressed("zoomout")and zoom_camera >= 0.3:
		self.zoom_camera -= 0.05
	
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
	else: 
		pass

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
	player.weapon_active = false
	weapon_dissapear()
	
func fire_sniper():

	var collision_point 
	if sniper_ray.is_colliding():
		collision_point = sniper_ray.get_collision_point()
	else:
		collision_point = null
	player.weapon_shot_sniper.emit(collision_point)
	player.weapon_active = false
	weapon_dissapear()
	player.sniper_shot.call_deferred("set_visible", true)
	await get_tree().create_timer(0.1).timeout
	player.sniper_shot.call_deferred("set_visible", false)
	
func _on_fire_power_timeout():
	player.weapon_energy += 12500

func weapon_dissapear():
	player.sniper.call_deferred("set_visible", false)
	player.granade.call_deferred("set_visible", false)
	player.bazooka.call_deferred("set_visible", false)


