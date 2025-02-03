extends State
class_name PlayerLand

@export var landspdmod : float = 0.8
@onready var animPlayer : AnimationPlayer = %AnimationPlayer

var animList : PackedStringArray = []

func _ready():
	animList = animPlayer.get_animation_list()

func enter():
	if "land" in animList:
		animPlayer.play("land")

func exit():
	animPlayer.pause()

func update(_delta: float):
	var chosenState = ""
	if Input.is_action_just_pressed("ui_accept"):
		chosenState = "PlayerJump"
	elif Input.is_action_just_pressed("attack"):
		if Input.is_action_pressed("input_up"):
			chosenState = "PlayerAtkUp"
		else:
			chosenState = "PlayerAtk1"
	#elif owner.is_moving_pressed():
		#chosenState = "PlayerMove"
	
	if owner.velocity.y > 0:
		chosenState = "PlayerFall"
	
	if chosenState != "":
		transition.emit(self, chosenState)
	
func physics_update(_delta: float):
	owner.velocity.x *= landspdmod


func _on_animation_finished(anim_name: String):
	if anim_name == "land":
		transition.emit(self, "PlayerIdle")
