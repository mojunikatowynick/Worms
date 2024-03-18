extends State
class_name  Innactive

@export var player: CharacterBody2D
@onready var AP = $"../../Animations/AnimationPlayer"

func Enter():
	$"../../Polygon2D/center/CrossHairSprite".visible = false
	
func Physics_update(_delta: float):
	
	if player.velocity != Vector2.ZERO and player.is_on_floor():
		player.velocity / 2
		if player.velocity.x >= -50 or player.velocity.x <= 50:
			player.velocity.x = 0
	
	
	if player.active == true:
		Transitioned.emit(self, "Active")
