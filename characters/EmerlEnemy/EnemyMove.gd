extends State
class_name EnemyMove

@onready var animPlayer : AnimationPlayer = %AnimationPlayer
@onready var detectPlayer : Area2D = %DetectPlayer

var animList : PackedStringArray = []

# Called when the node enters the scene tree for the first time.
func _ready():
	animList = animPlayer.get_animation_list()


func enter():
	if "move" in animList:
		animPlayer.play("move")

func exit():
	animPlayer.stop()

func update(_delta: float):
	var chosenState = ""
	
	if owner.moveDirection == 0:
		chosenState = "EnemyIdle"
	
	if owner.velocity.y > 0:
		chosenState = "EnemyFall"
	
	if chosenState != "":
		transition.emit(self, chosenState)

func physics_update(_delta: float):
	owner.velocity.x = owner.moveDirection * owner.moveSpd * _delta
