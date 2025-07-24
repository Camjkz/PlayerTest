extends State
class_name PlayerDash

signal lockDirection()
@onready var animPlayer : AnimationPlayer = %AnimationPlayer

@export var dashSpdX : int = 2000
@export var dashSpdY : int = -500
@onready var spdBurstTriggered : bool = true

var animList : PackedStringArray = []

func _ready():
	animList = animPlayer.get_animation_list()

func enter():
	lockDirection.emit(true)
	owner.bufferedAction = ""
	if "dash" in animList:
		animPlayer.play("dash")

func exit():
	lockDirection.emit(false)
	animPlayer.stop()

func update(_delta: float):
	pass
	#var chosenState = ""
	#
	#if chosenState != "":
		#transition.emit(self, chosenState)
	
func physics_update(_delta: float):
	if spdBurstTriggered:
		spdBurstTriggered = false;
		owner.velocity.x = dashSpdX * owner.side
		owner.velocity.y = dashSpdY


func _on_animation_finished(anim_name: String):
	if anim_name == "dash":
		transition.emit(self, "PlayerFall")
