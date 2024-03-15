extends CharacterBody2D
class_name Worm

@export var jump_speed: int = -350
@export var move_speed: int = 100
@export var hp = 100
var active: bool = false
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")
var weapon_active: bool = false

@onready var center_point = $Polygon2D/center
@onready var weapon_spawn = $Polygon2D/center/WeaponSpawn
@onready var cross_hair = $Polygon2D/center/CrossHair
@onready var AP = $Animations/AnimationPlayer
@onready var state = $StateMachine.current_state
@onready var sprite_worm = $Polygon2D
#weapons
var weapon_energy = 10000
#timer
@onready var timer_weapon_energy = $Timers/FirePower

signal weapon_shot(pos, direction, energy)

func _ready():
	hp_change()

func _physics_process(delta):
	
	velocity.y += gravity * delta
	sprite_scalling()
	move_and_slide()

	if hp <= 0:
		queue_free()

func sprite_scalling():
	if velocity.x > 0:
		sprite_worm.scale.x = 1
	elif velocity.x < 0:
		sprite_worm.scale.x = -1

func push_back(center, energy, damage):
		var fly_dir = center_point.global_position - center
		velocity = fly_dir.normalized() * energy
		hp -= damage
		hp_change()

func hp_change():
	$Control/TextureProgressBar.value = hp

func _on_button_toggled(toggled_on):
	if toggled_on:
		active = true
	else:
		active = false
