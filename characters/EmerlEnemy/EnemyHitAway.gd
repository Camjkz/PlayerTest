extends State
class_name EnemyHitAway

@onready var animPlayer : AnimationPlayer = %AnimationPlayer

@onready var animList : PackedStringArray = []

# Called when the node enters the scene tree for the first time.
func _ready():
	animList = animPlayer.get_animation_list()


func enter():
	if "knockback_away" in animList:
		animPlayer.play("knockback_away")
		

func exit():
	animPlayer.pause()

func update(_delta: float):
	var chosenState = ""
	owner.hitstun -= _delta
	if owner.hitstun < 0:
		owner.hitstun = 0
		chosenState = "EnemyHitFall"
	
	if owner.is_on_floor():
		chosenState = "EnemyKnockdown"
	
	transition.emit(self, chosenState)


func physics_update(_delta: float):
	pass

