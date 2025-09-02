extends State
class_name PlayerAtk1

signal lockDirection()
signal bufferAction()
@onready var animPlayer : AnimationPlayer = %AnimationPlayer
@onready var playerSprite : Sprite2D = %PlayerSprite

var animList : PackedStringArray = []

func _ready():
	animList = animPlayer.get_animation_list()

func enter():
	lockDirection.emit(true)
	
	if "atk1" in animList:
		animPlayer.play("atk1")

func exit():
	playerSprite.position.x = 0
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
		elif animPlayer.current_animation_position >= 0.4:
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
					chosenState = "PlayerAtk2"
			elif owner.is_moving_pressed():
				chosenState = "PlayerMove"
	else:
		chosenState = "PlayerIdle"
	
	if owner.velocity.y > 0:
		chosenState = "PlayerFall"
	
	if chosenState != "":
		transition.emit(self, chosenState)

func physics_update(_delta: float):
	pass
	
