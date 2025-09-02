extends State
class_name PlayerAAtkSpike

signal lockDirection()
@onready var animPlayer : AnimationPlayer = %AnimationPlayer
@onready var playerSprite : Sprite2D = %PlayerSprite


var animList : PackedStringArray = []

func _ready():
	animList = animPlayer.get_animation_list()

func enter():
	owner.bufferedAction = ""
	lockDirection.emit(true)
	if "airatk_spike" in animList:
		animPlayer.play("airatk_spike")

func exit():
	lockDirection.emit(false)
	animPlayer.stop()

func update(_delta: float):
	var chosenState = ""
	if animPlayer.is_playing():
		if owner.velocity.y == 0 and owner.is_on_floor():
			chosenState = "PlayerLand"
	else:
		if owner.velocity.y > 0:
			chosenState = "PlayerFall"
		else:
			print("huh?")
			chosenState = "PlayerIdle"
	
	if chosenState != "":
		transition.emit(self, chosenState)


func physics_update(_delta: float):
	pass
