extends State
class_name PlayerJump

signal jumpTrigger()
signal lockDirection()
@onready var animPlayer : AnimationPlayer = %AnimationPlayer

var animList : PackedStringArray = []

func _ready():
	animList = animPlayer.get_animation_list()

func enter():
	#lockDirection.emit(true)
	owner.bufferedAction = ""
	if "jump" in animList:
		animPlayer.play("jump")
	jumpTrigger.emit()

func exit():
	#lockDirection.emit(false)
	animPlayer.stop()

func update(_delta: float):
	var chosenState = ""
	if owner.velocity.y > 0:
		chosenState = "PlayerFall"
	if Input.is_action_just_pressed("attack"):
		chosenState = "PlayerAAtkSpike"
	
	if chosenState != "":
		transition.emit(self, chosenState)
	
func physics_update(_delta: float):
	pass


func _on_animation_finished(anim_name: String):
	if anim_name == "jump" and owner.is_on_floor():
		transition.emit(self, "PlayerIdle")
