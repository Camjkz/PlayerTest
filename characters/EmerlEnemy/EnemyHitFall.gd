extends State
class_name EnemyHitFall

@onready var animPlayer : AnimationPlayer = %AnimationPlayer

var animList : PackedStringArray = []

# Called when the node enters the scene tree for the first time.
func _ready():
	animList = animPlayer.get_animation_list()


func enter():
	if "knockback_fall" in animList:
		animPlayer.play("knockback_fall")

func exit():
	animPlayer.stop()

func update(_delta: float):
	var chosenState = ""
	if owner.is_on_floor():
		if owner.tumble:
			chosenState = "EnemyKnockdown"
		else:
			chosenState = "EnemyIdle"
	
	transition.emit(self, chosenState)


func physics_update(_delta: float):
	pass
