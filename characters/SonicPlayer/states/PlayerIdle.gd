extends State
class_name PlayerIdle

@onready var animPlayer : AnimationPlayer = %AnimationPlayer

var animList : PackedStringArray = []

func _ready():
	animList = animPlayer.get_animation_list()

func enter():
	if "idle" in animList:
		animPlayer.play("idle")

func exit():
	animPlayer.stop()

func update(_delta: float):
	var chosenState = ""
	if Input.is_action_just_pressed("ui_accept"):
		chosenState = "PlayerJump"
	elif Input.is_action_just_pressed("attack"):
		if Input.is_action_pressed("input_up"):
			chosenState = "PlayerAtkUp"
		else:
			chosenState = "PlayerAtk1"
	elif owner.is_moving_pressed():
		chosenState = "PlayerMove"
	
	if owner.velocity.y > 0:
		chosenState = "PlayerFall"
	
	if chosenState != "":
		transition.emit(self, chosenState)
	
func physics_update(_delta: float):
	pass
