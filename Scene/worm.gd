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
@onready var sniper = $Polygon2D/center/WeaponSprite/Sniper
@onready var granade = $Polygon2D/center/WeaponSprite/Granade
@onready var bazooka = $Polygon2D/center/WeaponSprite/Bazooka

#weapons
var weapon_energy = 10000
#timer
@onready var timer_weapon_energy = $Timers/FirePower

signal weapon_shot(pos, direction, energy)
signal weapon_shot_sniper(collision_point)
signal dead

func _ready():
	hp_change()
	sniper.call_deferred("set_visible", false)
	granade.call_deferred("set_visible", false)
	bazooka.call_deferred("set_visible", false)
	
func _physics_process(delta):
	velocity.y += gravity * delta
	sprite_scalling()
	move_and_slide()

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

func die_in_water():
	hp = 0
	var tween_worm= get_tree().create_tween()
	tween_worm.tween_property($".", "modulate", Color(1, 1, 1, 0), 1)
	self.active = false

func weapon_sprite_enabler():
	if Global.weapon_chosen == "bazooka":
		bazooka.call_deferred("set_visible", true)
		granade.call_deferred("set_visible", false)
		sniper.call_deferred("set_visible", false)
	if Global.weapon_chosen == "granade":
		bazooka.call_deferred("set_visible", false)
		granade.call_deferred("set_visible", true)
		sniper.call_deferred("set_visible", false)
	if Global.weapon_chosen == "sniper":
		bazooka.call_deferred("set_visible", false)
		granade.call_deferred("set_visible", false)
		sniper.call_deferred("set_visible", true)
	
