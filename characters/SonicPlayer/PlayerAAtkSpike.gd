extends State
class_name PlayerAAtkSpike

signal lockDirection()
@onready var animPlayer : AnimationPlayer = %AnimationPlayer
@onready var playerSprite : Sprite2D = %PlayerSprite
@export var hitbox : HitBox 
@onready var hitboxshapes : Array = []
@onready var maxindex : int = 0
@onready var hitboxpositions : Array = []
@onready var hitboxrotations : Array = []

var animList : PackedStringArray = []

func _ready():
	animList = animPlayer.get_animation_list()
	setup_hitboxes()

func enter():
	owner.bufferedAction = ""
	lockDirection.emit(true)
	if "airatk_spike" in animList:
		animPlayer.play("airatk_spike")

func exit():
	lockDirection.emit(false)
	animPlayer.pause()

func update(_delta: float):
	var chosenState = ""
	handle_anim_side_values()
	if animPlayer.is_playing():
		if owner.velocity.y == 0 and owner.is_on_floor():
			chosenState = "PlayerLand"
	else:
		if owner.velocity.y > 0:
			chosenState = "PlayerFall"
		else:
			print("huh?")
			chosenState = "PlayerIdle"
	
	if chosenState != "":
		transition.emit(self, chosenState)


func setup_hitboxes():
	hitboxshapes = []
	hitboxshapes = hitbox.get_children()
	for hitbox in hitboxshapes:
		hitboxpositions.append(hitbox.position.x)
		hitboxrotations.append(hitbox.rotation)
	maxindex = hitboxshapes.size()


func handle_anim_side_values():
	# bring sprite to face the correct direction
	if playerSprite.position.x != playerSprite.position.x * owner.side:
		playerSprite.position.x = playerSprite.position.x * owner.side
		# keep hitboxes facing the correct side
	var index : int = 0
	while index < maxindex:
		if hitboxpositions[index] < 0:
			hitboxshapes[index].position.x = -abs(hitboxshapes[index].position.x) * owner.side
		elif hitboxpositions[index] > 0:
			hitboxshapes[index].position.x = abs(hitboxshapes[index].position.x) * owner.side
		
		if hitboxrotations[index] < 0:
			hitboxshapes[index].rotation = -abs(hitboxshapes[index].rotation) * owner.side
		elif hitboxrotations[index] > 0:
			hitboxshapes[index].rotation = abs(hitboxshapes[index].rotation) * owner.side
		#print("Hitbox " + str(index+1) + " rotation: " + str(hitboxshapes[index].rotation))
		index += 1


func physics_update(_delta: float):
	pass
