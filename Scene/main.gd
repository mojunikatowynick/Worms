extends Node2D

var bazooka_scene: PackedScene = preload("res://Scene/bazooka.tscn")
var granade_scene: PackedScene = preload("res://Scene/granade.tscn")
var sniper_scene: PackedScene = preload("res://Scene/sniper.tscn")
var projectile = bazooka_scene.instantiate() as RigidBody2D

@onready var player_camera = $PlayerCamera

func _process(_delta):
	player_camera.position = Global.camera_pos

func _on_worm_weapon_shot(pos, direction, energy):
	weapon_choice(pos, direction, energy)

func weapon_choice(pos, direction, energy):
	if Global.weapon_chosen == "bazooka":
		projectile = bazooka_scene.instantiate() as RigidBody2D
		projectile.position = pos
		projectile.rotation_degrees = rad_to_deg(direction.angle())
		var power = direction * energy
		projectile.apply_force(power)
		$Projectiles.add_child(projectile)
	elif Global.weapon_chosen == "granade":
		projectile = granade_scene.instantiate() as RigidBody2D
		projectile.position = pos
		projectile.rotation_degrees = rad_to_deg(direction.angle())
		var power = direction * energy
		projectile.apply_force(power)
		$Projectiles.add_child(projectile)
	else:
		pass

func _on_worm_weapon_shot_sniper(collision_point):
	projectile = sniper_scene.instantiate() as Area2D
	projectile.position = collision_point
	$Projectiles.add_child(projectile)


func _on_ui_activate_worm():
	var worm = $TEAM1.get_child(0)
	worm.active = true
