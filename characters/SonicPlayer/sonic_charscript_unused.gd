extends Node2D

@onready var animation_player = %AnimationPlayer
@onready var char_physics = %SonicPlayerKinematic

#signals
signal TriggerJump()

var canFlip = true

# sus code
var bufferedAction = ""
var jumpTrigger = false
var startFalling = true

# Called when the node enters the scene tree for the first time.
func _ready():
	animation_player.play("idle")

#func _physics_process(delta):
	#

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	# handle orientation
	
	if canFlip:
		if Input.is_action_pressed("move_right") and !Input.is_action_pressed("move_left"):
			flip_char("right")
		elif Input.is_action_pressed("move_left") and !Input.is_action_pressed("move_right"):
			flip_char("left")
	
	canFlip = true
	
	if animation_player.current_animation == "idle":
		# handle inputs during idle
		if is_moving_pressed():
			# start movement
			animation_player.play("move")
		elif Input.is_action_just_pressed("ui_accept"):
			handle_jump_fall()
		elif Input.is_action_just_pressed("attack"):
			handle_attack()
	elif animation_player.current_animation == "move":
		if Input.is_action_just_pressed("ui_accept"):
			handle_jump_fall()
		elif Input.is_action_just_pressed("attack"):
			handle_attack()
		if is_moving_pressed():
			# continue moving
			pass
		else:
			animation_player.play("idle")
			startFalling = true
	elif animation_player.current_animation == "jump":
		handle_jump_fall()
	elif animation_player.current_animation == "fall":
		if char_physics.velocity.y == 0:
			animation_player.play("idle")
			startFalling = true
	elif is_attacking():
		# dont allow flip during attack
		canFlip = false
		handle_attack()
	else:
		if char_physics.velocity.y > 0 and !char_physics.is_on_floor() and startFalling:
			animation_player.play("fall")
			startFalling = false
		elif char_physics.velocity.y == 0 and char_physics.is_on_floor():
			startFalling = true
			if is_moving_pressed():
				# start movement
				animation_player.play("move")
			elif Input.is_action_just_pressed("ui_accept"):
				handle_jump_fall()
			elif Input.is_action_just_pressed("attack"):
				handle_attack()
			else:
				animation_player.play("idle")
				startFalling = true
		else:
			pass
			#print("hold jump animation end frame")
	
	# override any animation with fall if velocity.y > 0
	if char_physics.velocity.y > 0 and !char_physics.is_on_floor() and startFalling:
		animation_player.play("fall")
		startFalling = false

func is_attacking() -> bool:
	var atks = ["atk1", "atk2", "atk3"]
	return atks.has(animation_player.current_animation)

func is_jumping() -> bool:
	return (animation_player.current_animation == "jump" and !char_physics.is_on_floor())

func is_moving_pressed() -> bool:
	return (Input.is_action_pressed("move_left") or \
	Input.is_action_pressed("move_right")) and \
	!(Input.is_action_pressed("move_left") and \
	Input.is_action_pressed("move_right"))

func handle_jump_fall():
	if !is_jumping():
		if !is_attacking() or \
		(char_physics.velocity.y < 0 and (animation_player.current_animation == "idle" \
		or animation_player.current_animation == "move")):
			animation_player.play("jump")
			jumpTrigger = true
			TriggerJump.emit()
	else:
		if !char_physics.is_on_floor() and char_physics.velocity.y > 0:
			animation_player.play("fall")

func handle_attack():
	if !is_attacking() and char_physics.is_on_floor():
		animation_player.stop()
		animation_player.play("atk1")
	else:
		if animation_player.current_animation == "atk1":
			if animation_player.current_animation_position >= 0.10 and \
			animation_player.current_animation_position < 0.35:
				if Input.is_action_just_pressed("attack"):
					#nextActionBuffered = true
					bufferedAction = "attack"
				elif Input.is_action_just_pressed("ui_accept"):
					bufferedAction = "jump"
			if animation_player.current_animation_position >= 0.35:
				if Input.is_action_just_pressed("attack") or bufferedAction == "attack":
					print("buffered action: " + bufferedAction)
					animation_player.stop()
					animation_player.play("atk2")
					bufferedAction = ""
				elif Input.is_action_just_pressed("ui_accept") or bufferedAction == "jump":
					print("buffered action: " + bufferedAction)
					animation_player.stop()
					handle_jump_fall()
					bufferedAction = ""
		elif animation_player.current_animation == "atk2":
			if animation_player.current_animation_position >= 0.10 and \
			animation_player.current_animation_position < 0.35:
				if Input.is_action_just_pressed("attack"):
					#nextActionBuffered = true
					bufferedAction = "attack"
			if animation_player.current_animation_position >= 0.35:
				if Input.is_action_just_pressed("attack") or bufferedAction == "attack":
					animation_player.stop()
					animation_player.play("atk3")
				elif is_moving_pressed():
					animation_player.play("move")
				elif Input.is_action_just_pressed("ui_accept"):
					animation_player.stop()
					handle_jump_fall()

func flip_char(direction: String):
	if direction == "right":
		self.scale.x = 1
	elif direction == "left":
		self.scale.x = -1

