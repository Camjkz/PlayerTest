extends State
class_name EnemyKnockdown

@onready var animPlayer : AnimationPlayer = %AnimationPlayer

var animList : PackedStringArray = []

# Called when the node enters the scene tree for the first time.
func _ready():
	animList = animPlayer.get_animation_list()


func enter():
	owner.tumble = false
	if "knockdown" in animList:
		animPlayer.play("knockdown")

func exit():
	animPlayer.stop()

func update(_delta: float):
	pass


func physics_update(_delta: float):
	pass


func _on_animation_finished(anim_name):
	var chosenState = ""
	if anim_name == "knockdown":
		chosenState = "EnemyGetup"
	transition.emit(self, chosenState)
