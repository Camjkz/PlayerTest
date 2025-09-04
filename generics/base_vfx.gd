extends Node2D

@onready var animPlayer : AnimationPlayer = %AnimationPlayer

func _ready() -> void:
	animPlayer.play("play")


func _on_animation_player_animation_finished(anim_name: StringName) -> void:
	queue_free()
