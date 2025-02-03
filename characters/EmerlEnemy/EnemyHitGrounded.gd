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
	animPlayer.stop()

func update(_delta: float):
	pass


func physics_update(_delta: float):
	pass


func _on_animation_finished(anim_name: String):
	if anim_name == "get_hit_grounded":
		transition.emit(self, "EnemyIdle")
