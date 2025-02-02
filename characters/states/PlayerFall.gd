extends State
class_name PlayerFall

signal lockDirection()
@onready var animPlayer : AnimationPlayer = %AnimationPlayer

var animList : PackedStringArray = []

func _ready():
	animList = animPlayer.get_animation_list()

func enter():
	#lockDirection.emit(true)
	if "fall" in animList:
		animPlayer.play("fall")

func exit():
	#lockDirection.emit(false)
	animPlayer.stop()

func update(_delta: float):
	var chosenState : String = ""
	if Input.is_action_just_pressed("attack"):
		chosenState = "PlayerAAtkSpike"
	if owner.velocity.y <= 0:
		chosenState = "PlayerLand"
		
	if chosenState != "":
		transition.emit(self, chosenState)
	
func physics_update(_delta: float):
	pass
