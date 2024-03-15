extends Node2D

var bazooka_scene: PackedScene = preload("res://Scene/bazooka.tscn")
var granade_scene: PackedScene = preload("res://Scene/granade.tscn")
var sniper_scene: PackedScene = preload("res://Scene/sniper.tscn")
var projectile = bazooka_scene.instantiate() as RigidBody2D

@onready var bazooka_button = $Control/HBoxContainer/BazookaButton
@onready var granade_button = $Control/HBoxContainer/GranadeButton



func _on_granade_button_pressed():
	Global.weapon_chosen = "granade"


func _on_bazooka_button_pressed():
	Global.weapon_chosen = "bazooka"


func _on_worm_weapon_shot(pos, direction, energy):
	weapon_choice()
	projectile.position = pos
	projectile.rotation_degrees = rad_to_deg(direction.angle())
	var power = direction * energy
	projectile.apply_force(power)
	$Projectiles.add_child(projectile)


func weapon_choice():
	if Global.weapon_chosen == "bazooka":
		projectile = bazooka_scene.instantiate() as RigidBody2D
	elif Global.weapon_chosen == "granade":
		projectile = granade_scene.instantiate() as RigidBody2D
	elif Global.weapon_chosen == "sniper":
		projectile = sniper_scene.instantiate() as Area2D
	else:
		projectile = bazooka_scene.instantiate() as RigidBody2D
