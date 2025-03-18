extends State
class_name PlayerMoveStop

@onready var animPlayer : AnimationPlayer = %AnimationPlayer

var animList : PackedStringArray = []
var currentSide : int = 0

func _ready():
	animList = animPlayer.get_animation_list()

func enter():
	currentSide = owner.side
	if "stop" in animList:
		animPlayer.play("stop")

func exit():
	animPlayer.stop()

func update(_delta: float):
	var chosenState = ""
	if Input.is_action_just_pressed("ui_accept"):
		chosenState = "PlayerJump"
	elif Input.is_action_just_pressed("attack"):
		if Input.is_action_pressed("input_up"):
			chosenState = "PlayerAtkUp"
		elif Input.is_action_pressed("input_down"):
			chosenState = "PlayerAtkDown"
		else:
			chosenState = "PlayerAtk1"
	elif owner.is_moving_pressed():
		if currentSide != owner.side:
			if abs(owner.velocity.x) < 200:
				chosenState = "PlayerIdleTurn"
			else:
				chosenState = "PlayerMoveTurn"
		else:
			chosenState = "PlayerMove"
	
	if owner.velocity.y > 0:
		chosenState = "PlayerFall"
	
	if chosenState != "":
		transition.emit(self, chosenState)
	
func physics_update(_delta: float):
	pass


func _on_animation_finished(anim_name):
	if anim_name == "stop":
		transition.emit(self, "PlayerIdle")
