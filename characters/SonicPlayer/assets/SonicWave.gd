extends Node2D

@export var speedX = 1500
@export var lifetime = 1
@onready var timeleft = 0
@onready var animPlayer : AnimationPlayer = %AnimationPlayer
@onready var waveSprite : Sprite2D = %WaveSprite
@onready var hitbox : HitBox = %WaveHitbox
@onready var side
@onready var projectileOwner

# Called when the node enters the scene tree for the first time.
func _ready():
	timeleft = lifetime
	waveSprite.scale.x = waveSprite.scale.x * side
	hitbox.hitboxArea.position.x = hitbox.hitboxArea.position.x * side
	
	animPlayer.play("launch")
	

func setParams(sideVal:int):
	side = sideVal
	

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
