extends CanvasLayer

signal activate_worm()
signal next_worm()
signal weapon_sprite()
@onready var round_timer = $RoundTimerContainer/VBoxContainer

func _ready():
	var tween_logo = get_tree().create_tween()
	tween_logo.tween_property($Logo/LogoContainer/Sprite2D, "modulate", Color(1, 1, 1), 2)
	tween_logo.tween_property($Logo/LogoContainer/Play, "visible", true, 0.5)
	tween_logo.tween_property($Logo/LogoContainer/Sprite2D, "position", Vector2(98, -150), 2)
	round_timer.call_deferred("set_visible", false)
	$WeaponMenu.call_deferred("set_visible", false)

func round_start():
	round_timer.call_deferred("set_visible", true)
	$WeaponMenu.call_deferred("set_visible", true)
	round_timer.modulate = Color(1, 1, 1)
	$RoundTimerContainer/VBoxContainer/RoundTimer.text = str(Global.round_timer)

func timer_update():
	$RoundTimerContainer/VBoxContainer/RoundTimer.text = str(Global.round_timer)
	if Global.round_timer <= 5:
		round_timer.modulate = Color(0.619, 0, 0)
	
func round_finish():
	round_timer.call_deferred("set_visible", false)
	$WeaponMenu.call_deferred("set_visible", false)
	var tween = get_tree().create_tween()
	tween.set_parallel(true)
	tween.tween_property($WeaponMenu, "anchor_left", 0, 0.5)
	tween.tween_property($WeaponMenu, "anchor_right", 0, 0.5)
	
func _on_bazooka_button_pressed():
	Global.weapon_chosen = "bazooka"
	weapon_sprite.emit()

func _on_granade_button_pressed():
	Global.weapon_chosen = "granade"
	weapon_sprite.emit()
	
func _on_sniper_button_pressed():
	Global.weapon_chosen = "sniper"
	weapon_sprite.emit()
	
func _on_next_worm_pressed():
	next_worm.emit()

func end_game():
	if get_parent().team1.size() <= 0:
		$Control/Label2.call_deferred("set_visible", true)
	if get_parent().team2.size() <= 0:
		$Control/Label.call_deferred("set_visible", true)

func pick_weapon():
	$Timer/Label3timer.start()
	$Control/Label3.call_deferred("set_visible", true)
func _on_label_3_timer_timeout():
	$Control/Label3.call_deferred("set_visible", false)


func _on_play_pressed():
	activate_worm.emit()
	$Logo.call_deferred("set_visible", false)

func _on_wm_button_toggled(toggled_on):
	if toggled_on:
		var tween = get_tree().create_tween()
		tween.set_parallel(true)
		tween.tween_property($WeaponMenu, "anchor_left", 0.062, 0.5)
		tween.tween_property($WeaponMenu, "anchor_right", 0.062, 0.5)
	else :
		var tween = get_tree().create_tween()
		tween.set_parallel(true)
		tween.tween_property($WeaponMenu, "anchor_left", 0, 0.5)
		tween.tween_property($WeaponMenu, "anchor_right", 0, 0.5)

