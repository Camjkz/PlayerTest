extends State
class_name EnemyIdle

@onready var animPlayer : AnimationPlayer = %AnimationPlayer

var animList : PackedStringArray = []

# Called when the node enters the scene tree for the first time.
func _ready():
	animList = animPlayer.get_animation_list()


func enter():
	if "idle" in animList:
		animPlayer.play("idle")

func exit():
	animPlayer.stop()

func update(_delta: float):
	var chosenState = ""
	if owner.moveDirection != 0:
		chosenState = "EnemyMove"
	
	if owner.velocity.y > 0:
		chosenState = "EnemyFall"
	
	if chosenState != "":
		transition.emit(self, chosenState)


func physics_update(_delta: float):
	pass
