extends State
class_name PlayerAtk3

signal lockDirection()
@onready var animPlayer : AnimationPlayer = %AnimationPlayer
@onready var maxindex : int = 0

var animList : PackedStringArray = []

func _ready():
	animList = animPlayer.get_animation_list()

func enter():
	owner.bufferedAction = ""
	lockDirection.emit(true)
	if "atk3" in animList:
		animPlayer.play("atk3")

func exit():
	lockDirection.emit(false)
	animPlayer.pause()

func update(_delta: float):
	var chosenState = ""
	if animPlayer.is_playing():
		pass
	else:
		chosenState = "PlayerIdle"
	
	if owner.velocity.y > 0:
		chosenState = "PlayerFall"
	
	if chosenState != "":
		transition.emit(self, chosenState)


func physics_update(_delta: float):
	pass
