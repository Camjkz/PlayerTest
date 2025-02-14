extends State
class_name EnemyHitGrounded

@onready var animPlayer : AnimationPlayer = %AnimationPlayer

var animList : PackedStringArray = []

# Called when the node enters the scene tree for the first time.
func _ready():
	animList = animPlayer.get_animation_list()


func enter():
	if "get_hit_grounded" in animList:
		animPlayer.play("get_hit_grounded")

func exit():
	animPlayer.pause()

func update(_delta: float):
	var chosenState = ""
	owner.hitstun -= _delta
	if owner.hitstun < 0:
		owner.hitstun = 0
		chosenState = "EnemyIdle"
	
	transition.emit(self, chosenState)


func physics_update(_delta: float):
	pass

