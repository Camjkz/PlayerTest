extends State
class_name EnemyMove

@onready var animPlayer : AnimationPlayer = %AnimationPlayer

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
	pass


func physics_update(_delta: float):
	pass
