extends State
class_name PlayerAtkUp

signal lockDirection()
signal bufferAction()
@onready var animPlayer : AnimationPlayer = %AnimationPlayer
@onready var playerSprite : Sprite2D = %PlayerSprite

var animList : PackedStringArray = []

func _ready():
	animList = animPlayer.get_animation_list()

func enter():
	owner.bufferedAction = ""
	lockDirection.emit(true)
	if "atkup" in animList:
		animPlayer.play("atkup")

func exit():
	lockDirection.emit(false)
	animPlayer.pause()

func update(_delta: float):
	var chosenState = ""
	if animPlayer.is_playing():
		if animPlayer.current_animation_position >= 0.2 and \
		animPlayer.current_animation_position < 0.6:
			if Input.is_action_just_pressed("ui_accept"):
				bufferAction.emit("PlayerJump")
				print("buffer jump")
		elif animPlayer.current_animation_position >= 0.6:
			if owner.bufferedAction == "PlayerJump" or \
			Input.is_action_just_pressed("ui_accept"):
				chosenState = "PlayerJump"
	else:
		chosenState = "PlayerIdle"
	
	if owner.velocity.y > 0:
		chosenState = "PlayerFall"
	
	if chosenState != "":
		transition.emit(self, chosenState)


func physics_update(_delta: float):
	pass


func _on_animation_finished(anim_name):
	if anim_name == "atkup":
		pass
		
