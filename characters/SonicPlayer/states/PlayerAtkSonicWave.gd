extends State
class_name PlayerAtkSonicWave

signal lockDirection()
signal bufferAction()
@onready var animPlayer : AnimationPlayer = %AnimationPlayer
@onready var playerSprite : Sprite2D = %PlayerSprite

@export var sonicwave : PackedScene
@export var spawnoffset_x = 0
@export var spawnoffset_y = 0
var sonicwavechild : Node2D
@onready var projectilespawned : bool = false

var animList : PackedStringArray = []

func _ready():
	animList = animPlayer.get_animation_list()
	#setup_hitboxes()

func enter():
	lockDirection.emit(true)
	if "atksonicwave" in animList:
		sonicwavechild = sonicwave.instantiate()
		projectilespawned = false
		animPlayer.play("atksonicwave")

func exit():
	playerSprite.position.x = 0
	lockDirection.emit(false)
	animPlayer.pause()

func update(_delta: float):
	var chosenState = ""
	#handle_anim_side_values()
	if animPlayer.is_playing():
		if animPlayer.current_animation_position >= 0.5 && !projectilespawned:
			print(get_tree().current_scene.name)
			sonicwavechild.setParams(owner.side)
			sonicwavechild.projectileOwner = owner
			get_tree().current_scene.add_child(sonicwavechild)
			projectilespawned = true
			sonicwavechild.global_position = playerSprite.global_position
			sonicwavechild.global_position.x += spawnoffset_x * owner.side
			sonicwavechild.global_position.y += spawnoffset_y + 70
	else:
		chosenState = "PlayerIdle"
	
	if owner.velocity.y > 0:
		chosenState = "PlayerFall"
	
	if chosenState != "":
		transition.emit(self, chosenState)

func physics_update(_delta: float):
	pass
	
