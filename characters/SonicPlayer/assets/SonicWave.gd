extends Node2D

@export var speedX = 1500
@export var lifetime = 1
@onready var timeleft = 0
@onready var animPlayer : AnimationPlayer = %AnimationPlayer
@onready var waveSprite : Sprite2D = %WaveSprite
@onready var side = 1

# Called when the node enters the scene tree for the first time.
func _ready():
	timeleft = lifetime
	animPlayer.play("launch")
	

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if !animPlayer.is_playing():
		animPlayer.play("travel")
	if timeleft > 0:
		timeleft -= delta
	
	if timeleft <= 0:
		queue_free()
		print("Projectile died")

func _physics_process(delta):
	if animPlayer.current_animation == "travel":
		position.x += speedX * delta * side
