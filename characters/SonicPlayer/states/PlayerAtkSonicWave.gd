extends State
class_name PlayerAtkSonicWave

signal lockDirection()
signal bufferAction()
@onready var animPlayer : AnimationPlayer = %AnimationPlayer
@onready var playerSprite : Sprite2D = %PlayerSprite
#@export var hitbox : HitBox 
#@onready var hitboxshapes : Array = []
@onready var maxindex : int = 0
#@onready var hitboxpositions : Array = []
#@onready var hitboxrotations : Array = []
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
	handle_anim_side_values()
	if animPlayer.is_playing():
		if animPlayer.current_animation_position >= 0.5 && !projectilespawned:
			print(get_tree().current_scene.name)
			get_tree().current_scene.add_child(sonicwavechild)
			sonicwavechild.side = owner.side
			projectilespawned = true
			sonicwavechild.global_position = playerSprite.global_position
			sonicwavechild.global_position.x += spawnoffset_x * owner.side
			sonicwavechild.global_position.y += spawnoffset_y
			print(sonicwavechild.global_position)
			print(playerSprite.global_position)
	else:
		chosenState = "PlayerIdle"
	
	if owner.velocity.y > 0:
		chosenState = "PlayerFall"
	
	if chosenState != "":
		transition.emit(self, chosenState)


#func setup_hitboxes():
	#hitboxshapes = []
	#hitboxshapes = hitbox.get_children()
	#for hitbox in hitboxshapes:
		##hitboxpositions.append(hitbox.position.x)
		#hitboxrotations.append(hitbox.rotation)
	#maxindex = hitboxshapes.size()
	
	
func handle_anim_side_values():
	# bring sprite to face the correct direction
	if playerSprite.position.x != playerSprite.position.x * owner.side:
		playerSprite.position.x = playerSprite.position.x * owner.side
		# keep hitboxes facing the correct side
	#var index : int = 0
	#while index < maxindex:
		#hitboxshapes[index].position.x = hitboxshapes[index].position.x * owner.side
		##if hitboxpositions[index] < 0:
			##hitboxshapes[index].position.x = -abs(hitboxshapes[index].position.x) * owner.side
		##elif hitboxpositions[index] > 0:
			##hitboxshapes[index].position.x = abs(hitboxshapes[index].position.x) * owner.side
		#
		#if hitboxrotations[index] < 0:
			#hitboxshapes[index].rotation = -abs(hitboxshapes[index].rotation) * owner.side
		#elif hitboxrotations[index] > 0:
			#hitboxshapes[index].rotation = abs(hitboxshapes[index].rotation) * owner.side
		##print("Hitbox " + str(index+1) + " rotation: " + str(hitboxshapes[index].rotation))
		#index += 1

func physics_update(_delta: float):
	pass
	
