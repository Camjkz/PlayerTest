extends State
class_name PlayerMove

@onready var animPlayer : AnimationPlayer = %AnimationPlayer

var animList : PackedStringArray = []
var currentSide : int = 0
var currentSideDuration : float = 0

func _ready():
	animList = animPlayer.get_animation_list()

func enter():
	currentSide = owner.side
	if "move" in animList:
		animPlayer.play("move")

func exit():
	animPlayer.stop()

func update(_delta: float):
	currentSideDuration += _delta
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
	elif Input.is_action_just_pressed("special"):
		chosenState = "PlayerAtkSonicWave"
	#elif ((Input.is_action_just_pressed("move_left") and currentSide == -1) or 
	#(Input.is_action_just_pressed("move_right") and currentSide == 1)) and currentSideDuration <= 0.2:
		#print("Dash!")
		#pass
	if owner.is_moving_pressed():
		if currentSide != owner.side:
			chosenState = "PlayerMoveTurn"
	else:
		if abs(owner.velocity.x) >= 540:
			chosenState = "PlayerMoveStop"
		else:
			chosenState = "PlayerIdle"

	if owner.velocity.y > 0:
		chosenState = "PlayerFall"

	if chosenState != "":
		transition.emit(self, chosenState)
	
func physics_update(_delta: float):
	pass
