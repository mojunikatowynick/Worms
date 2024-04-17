extends Node2D

var bazooka_scene: PackedScene = preload("res://Scene/bazooka.tscn")
var granade_scene: PackedScene = preload("res://Scene/granade.tscn")
var sniper_scene: PackedScene = preload("res://Scene/sniper.tscn")
var grave_scene: PackedScene = preload("res://Scene/grave.tscn")

var projectile = bazooka_scene.instantiate() as RigidBody2D
var worm = null
var zoom = 1
var game_on = false
var round_on = false

var team1 = []
var team2 = []
var both_teams = []
var first_team = []
var last_team = []
var new_team = []
var last_worm

@onready var TEAM_number_1 = $TEAM1
@onready var TEAM_number_2 = $TEAM2
@onready var camera_vector: Vector2 = Vector2(0.7, 0.7)
@onready var player_camera = $PlayerCamera
@onready var camera_place_innactive = $CameraPovInnactive
var camera_move_speed = 100

func _ready():
	team1 = $TEAM1.get_children()
	for child in team1:
		child.get_child(0).self_modulate = Color(0.498039, 1, 0.831373, 1) #red
		
	team2 = $TEAM2.get_children()
	for child in team2:
		child.get_child(0).self_modulate = Color(0.862745, 0.0784314, 0.235294, 1) #blue
		
	camera_vector = Vector2(0.7, 0.7)
	
	team1.shuffle()
	team2.shuffle()
	
func _process(delta):

	if Input.is_action_just_pressed("fire") and Global.weapon_chosen == "null" and game_on:
		$UI.pick_weapon()
	else:
		pass
	camera_control(delta)

func round_timer_on():
	if game_on:
		Global.round_timer = 45
		await get_tree().create_timer(3).timeout
		$UI.round_start()
		$Timer/RoundTimer.start()
		round_on = true
	else :
		pass

func _on_round_timer_timeout():
	Global.round_timer -= 1
	$UI.timer_update()
	if Global.round_timer <= 0:
		$UI.round_finish()
		$Timer/RoundTimer.stop()
		Global.round_timer = 45
		finish_round()

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
	finish_round_timer()
	
func camera_control(delta):
	if worm == null or game_on == false:
		var tween = get_tree().create_tween()
		tween.set_parallel(true)
		tween.tween_property(player_camera, "zoom", camera_vector, 1)
		tween.tween_property(player_camera, "position", camera_place_innactive.global_position, 1)

		camera_place_innactive.position.x += camera_move_speed * delta
		if camera_place_innactive.position.x >= 2100:
			camera_move_speed = -100
		elif camera_place_innactive.position.x <= -1200:
			camera_move_speed = 100
	else :
		pass
		
func _on_worm_weapon_shot_sniper(collision_point):

	if collision_point != null:
		projectile = sniper_scene.instantiate() as Area2D
		projectile.position = collision_point
		$Projectiles.add_child(projectile)
	else:
		pass
		
	finish_round_timer()
	
func finish_round_timer():
	if round_on:
		$UI.round_finish()
		$Timer/RoundTimer.stop()
		Global.round_timer = 45
		$"Timer/WormTimer".start()
	else :
		finish_round()

func _on_ui_activate_worm():
	game_on = true
	both_teams = [team1, team2]
	first_team = both_teams.pick_random()
	worm = first_team.front()
	worm.active = true
	round_timer_on()
	
func _on_ui_next_worm():
	pick_next_team_worm()
	$UI.round_finish()
	$Timer/RoundTimer.stop()
	Global.round_timer = 45
	finish_round()

func pick_team():
	last_team = both_teams.find(first_team)
	if last_team == 0:
		last_team = 1
	elif last_team == 1:
		last_team = 0
	new_team = both_teams[last_team]
	
func pick_next_worm():
	if game_on:
		worm.active = false
		worm = new_team.front()
		await get_tree().create_timer(1).timeout
		worm.active = true
		new_team.erase(worm)
		new_team.append(worm)
		first_team = both_teams[last_team]
	else:
		pass
	
func pick_next_team_worm():
	pick_team()
	pick_next_worm()
	round_timer_on()
	
func _on_worm_dead():
	pick_next_team_worm()

func _on_worm_timer_timeout():
	finish_round()

func finish_round():
	round_on = false
	for dead_worms in team1:
		if dead_worms.hp <= 0:
			var grave = grave_scene.instantiate() as CharacterBody2D
			grave.position = dead_worms.global_position
			$Graves.call_deferred("add_child", grave)
			team1.erase(dead_worms)
			dead_worms.queue_free()
	for dead_worms in team2:
		if dead_worms.hp <= 0:
			var grave = grave_scene.instantiate() as CharacterBody2D
			grave.position = dead_worms.global_position
			$Graves.call_deferred("add_child", grave)
			team2.erase(dead_worms)
			dead_worms.queue_free()
	if team1.size() <= 0 or team2.size() <= 0:
		game_on = false
		worm.active = false
		$UI.end_game()
	else: 
		pick_next_team_worm()



func _on_ui_weapon_sprite():
	if worm.active and "weapon_sprite_enabler" in worm:
		worm.weapon_sprite_enabler()
	else:
		pass

func _on_ui_reload_game():
	get_tree().reload_current_scene()
