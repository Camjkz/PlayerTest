extends Node2D

@onready var animplayer : AnimationPlayer = %AnimationPlayer


# Called when the node enters the scene tree for the first time.
func _ready():
	animplayer.play("play")


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func _on_animation_player_animation_finished(anim_name):
	Hitvfx.finishAnim.emit(self)
