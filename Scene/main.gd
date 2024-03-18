extends Node2D

var bazooka_scene: PackedScene = preload("res://Scene/bazooka.tscn")
var granade_scene: PackedScene = preload("res://Scene/granade.tscn")
var sniper_scene: PackedScene = preload("res://Scene/sniper.tscn")
var projectile = bazooka_scene.instantiate() as RigidBody2D
var worm = null
var zoom = 1

@onready var TEAM_number_1 = $TEAM1
@onready var TEAM_number_2 = $TEAM2

@onready var player_camera = $PlayerCamera
@onready var camera_place_innactive = $CameraPovInnactive
var camera_move_speed = 100

func _ready():
	var team1 = $TEAM1.get_children()
	for child in team1:
		child.get_child(0).self_modulate = Color(0.498039, 1, 0.831373, 1)
	
	var team2 = $TEAM2.get_children()
	for child in team2:
		child.get_child(0).self_modulate = Color(0.862745, 0.0784314, 0.235294, 1)
		
	print(team1,team2)
		
		
func _process(delta):

	camera_control(delta)

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
	finish_round()
	
func camera_control(delta):
	if worm == null:
		player_camera.zoom = Vector2(0.5, 0.5)
		player_camera.position = camera_place_innactive.global_position

		camera_place_innactive.position.x += camera_move_speed * delta
		if camera_place_innactive.position.x >= 2100:
			camera_move_speed = -100
		elif camera_place_innactive.position.x <= -1200:
			camera_move_speed = 100
	else :
		player_camera.zoom = Vector2(zoom, zoom)
		player_camera.position = Global.camera_pos
		
		
func _on_worm_weapon_shot_sniper(collision_point):
	if collision_point != null:
		projectile = sniper_scene.instantiate() as Area2D
		projectile.position = collision_point
		$Projectiles.add_child(projectile)
	else:
		pass
		
	finish_round()
	
func _on_ui_activate_worm():
	
	var both_teams = [TEAM_number_1, TEAM_number_2]
	var first_team = both_teams.pick_random()
	worm = first_team.get_child(0)
	worm.active = true

func finish_round():
	print("finished round")
