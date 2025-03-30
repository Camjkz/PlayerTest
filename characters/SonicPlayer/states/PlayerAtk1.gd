extends State
class_name PlayerAtk1

signal lockDirection()
signal bufferAction()
@onready var animPlayer : AnimationPlayer = %AnimationPlayer
@onready var playerSprite : Sprite2D = %PlayerSprite
@export var hitbox : HitBox 
@onready var hitboxshapes : Array = []
@onready var maxindex : int = 0
#@onready var hitboxpositions : Array = []
@onready var hitboxrotations : Array = []

var animList : PackedStringArray = []

func _ready():
	animList = animPlayer.get_animation_list()
	setup_hitboxes()

func enter():
	lockDirection.emit(true)
	
	if "atk1" in animList:
		animPlayer.play("atk1")

func exit():
	playerSprite.position.x = 0
	lockDirection.emit(false)
	animPlayer.pause()

func update(_delta: float):
	var chosenState = ""
	handle_anim_side_values()
	if animPlayer.is_playing():
		if animPlayer.current_animation_position >= 0.2 and \
		animPlayer.current_animation_position < 0.4:
			if Input.is_action_just_pressed("ui_accept"):
				bufferAction.emit("PlayerJump")
			elif Input.is_action_just_pressed("attack"):
				bufferAction.emit("PlayerAtk")
		elif animPlayer.current_animation_position >= 0.4:
			if owner.bufferedAction == "PlayerJump" or \
			Input.is_action_just_pressed("ui_accept"):
				chosenState = "PlayerJump"
			elif owner.bufferedAction == "PlayerAtk" or \
			Input.is_action_just_pressed("attack"):
				if Input.is_action_pressed("input_up"):
					chosenState = "PlayerAtkUp"
				elif Input.is_action_pressed("input_down"):
					chosenState = "PlayerAtkDown"
				else:
					chosenState = "PlayerAtk2"
			elif owner.is_moving_pressed():
				chosenState = "PlayerMove"
	else:
		chosenState = "PlayerIdle"
	
	if owner.velocity.y > 0:
		chosenState = "PlayerFall"
	
	if chosenState != "":
		transition.emit(self, chosenState)


func setup_hitboxes():
	hitboxshapes = []
	hitboxshapes = hitbox.get_children()
	for hitbox in hitboxshapes:
		#hitboxpositions.append(hitbox.position.x)
		hitboxrotations.append(hitbox.rotation)
	maxindex = hitboxshapes.size()
	
	
func handle_anim_side_values():
	# bring sprite to face the correct direction
	if playerSprite.position.x != playerSprite.position.x * owner.side:
		playerSprite.position.x = playerSprite.position.x * owner.side
		# keep hitboxes facing the correct side
	var index : int = 0
	while index < maxindex:
		hitboxshapes[index].position.x = hitboxshapes[index].position.x * owner.side
		#if hitboxpositions[index] < 0:
			#hitboxshapes[index].position.x = -abs(hitboxshapes[index].position.x) * owner.side
		#elif hitboxpositions[index] > 0:
			#hitboxshapes[index].position.x = abs(hitboxshapes[index].position.x) * owner.side
		
		if hitboxrotations[index] < 0:
			hitboxshapes[index].rotation = -abs(hitboxshapes[index].rotation) * owner.side
		elif hitboxrotations[index] > 0:
			hitboxshapes[index].rotation = abs(hitboxshapes[index].rotation) * owner.side
		#print("Hitbox " + str(index+1) + " rotation: " + str(hitboxshapes[index].rotation))
		index += 1

func physics_update(_delta: float):
	pass
	
