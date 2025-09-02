extends State
class_name PlayerAtk2

signal lockDirection()
signal bufferAction()
@export var ATK_MOVEX = 400.0
@onready var triggerMove : bool = false
@onready var animPlayer : AnimationPlayer = %AnimationPlayer
@onready var playerSprite : Sprite2D = %PlayerSprite

var animList : PackedStringArray = []

func _ready():
	animList = animPlayer.get_animation_list()

func enter():
	triggerMove = true
	lockDirection.emit(true)
	owner.bufferedAction = ""

	if "atk2" in animList:
		animPlayer.play("atk2")

func exit():
	lockDirection.emit(false)
	animPlayer.pause()

func update(_delta: float):
	var chosenState = ""
	if animPlayer.is_playing():
		if animPlayer.current_animation_position >= 0.2 and \
		animPlayer.current_animation_position < 0.4:
			if Input.is_action_just_pressed("ui_accept"):
				bufferAction.emit("PlayerJump")
			elif Input.is_action_just_pressed("attack"):
				bufferAction.emit("PlayerAtk")
		if animPlayer.current_animation_position >= 0.4:
			if owner.bufferedAction == "PlayerJump" or \
			Input.is_action_just_pressed("ui_accept"):
				chosenState = "PlayerJump"
			elif owner.bufferedAction == "PlayerAtk" or \
			Input.is_action_just_pressed("attack"):
				if Input.is_action_pressed("input_up"):
					chosenState = "PlayerAtkUp"
				elif Input.is_action_pressed("input_down"):
					chosenState = "PlayerAtkDown"
				else:
					chosenState = "PlayerAtk3"
			elif owner.is_moving_pressed():
				chosenState = "PlayerMove"
	else:
		chosenState = "PlayerIdle"
	
	if owner.velocity.y > 0:
		chosenState = "PlayerFall"
	
	if chosenState != "":
		transition.emit(self, chosenState)


func physics_update(_delta: float):
	if triggerMove:
		triggerMove = false;
		owner.velocity.x = ATK_MOVEX * owner.side
	
