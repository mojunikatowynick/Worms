extends CanvasLayer

signal activate_worm()
signal next_worm()

func _on_active_button_pressed():
	activate_worm.emit()


func _on_bazooka_button_pressed():
	Global.weapon_chosen = "bazooka"


func _on_granade_button_pressed():
	Global.weapon_chosen = "granade"


func _on_sniper_button_pressed():
	Global.weapon_chosen = "sniper"



func _on_next_worm_pressed():
	next_worm.emit()
