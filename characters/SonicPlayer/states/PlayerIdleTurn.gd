extends State
class_name PlayerIdleTurn

@onready var animPlayer : AnimationPlayer = %AnimationPlayer

var animList : PackedStringArray = []

func _ready():
	animList = animPlayer.get_animation_list()

func enter():
	if "turn" in animList:
		animPlayer.play("turn")

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
	#elif owner.is_moving_pressed():
		#chosenState = "PlayerMove"
	elif Input.is_action_just_pressed("special"):
		chosenState = "PlayerAtkSonicWave"
	if owner.velocity.y > 0:
		chosenState = "PlayerFall"
	
	if chosenState != "":
		transition.emit(self, chosenState)
	
func physics_update(_delta: float):
	owner.velocity.x *= 0.8


func _on_animation_finished(anim_name):
	if anim_name == "turn":
		transition.emit(self, "PlayerIdle")
