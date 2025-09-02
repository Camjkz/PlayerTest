extends State
class_name PlayerAtkDown

signal lockDirection()
signal bufferAction()
@export var ATK_MOVEX = -400.0
@onready var triggerMove : bool = false
@onready var animPlayer : AnimationPlayer = %AnimationPlayer
@onready var playerSprite : Sprite2D = %PlayerSprite

var animList : PackedStringArray = []

func _ready():
	animList = animPlayer.get_animation_list()

func enter():
	owner.bufferedAction = ""
	lockDirection.emit(true)
	if "atkdown" in animList:
		animPlayer.play("atkdown")

func exit():
	lockDirection.emit(false)
	animPlayer.pause()

func update(_delta: float):
	var chosenState = ""
	if animPlayer.is_playing():
		if animPlayer.current_animation_position >= 1.2:
			triggerMove = true
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
