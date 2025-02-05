extends State
class_name EnemyGetup

@onready var animPlayer : AnimationPlayer = %AnimationPlayer

var animList : PackedStringArray = []

# Called when the node enters the scene tree for the first time.
func _ready():
	animList = animPlayer.get_animation_list()


func enter():
	if "getup" in animList:
		animPlayer.play("getup")

func exit():
	animPlayer.pause()

func update(_delta: float):
	pass


func physics_update(_delta: float):
	pass


func _on_animation_finished(anim_name):
	var chosenState = ""
	if anim_name == "getup":
		chosenState = "EnemyIdle"
	transition.emit(self, chosenState)
