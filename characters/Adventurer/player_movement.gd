extends CharacterBody2D


@export var SPEED = 300.0
@export var JUMP_VELOCITY = -400.0
@export var movespdModOnAtk = 0.3
@onready var animation_player = %AnimationPlayer

# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")
var canFlip = true

# Bufferable actions
#var nextActionBuffered = false
var bufferedAction = ""
var debugStop = false

# sus code
var jumpTrigger = false

func _ready() -> void:
	animation_player.play("idle")

func _physics_process(delta):
	# Add the gravity.
	if not is_on_floor():
		velocity.y += gravity * delta

	# Handle jump.
	if jumpTrigger and is_on_floor() and !is_attacking():
		velocity.y = JUMP_VELOCITY
		jumpTrigger = false

	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	var direction = Input.get_axis("move_left", "move_right")
	if direction:
		var prevVel = velocity
		velocity.x = direction * SPEED
		if is_attacking():
			velocity = prevVel.lerp(Vector2(0, velocity.y), movespdModOnAtk)
			#velocity.x = round(prevVel * movespdModOnAtk)
			#velocity.x = 0
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)

	move_and_slide()

func _process(delta):
	# handle orientation
	if canFlip:
		if Input.is_action_pressed("move_right") and !Input.is_action_pressed("move_left"):
			flip_char("right")
		elif Input.is_action_pressed("move_left") and !Input.is_action_pressed("move_right"):
			flip_char("left")
	
	# reset canFlip value and check state to determine whether can flip next frame
	canFlip = true
	# handle current anim -> next anim
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
		elif is_moving_pressed():
			# continue moving
			pass
		else:
			animation_player.play("idle")
	elif animation_player.current_animation == "jump":
		handle_jump_fall()
	elif is_attacking():
		# dont allow flip during attack
		canFlip = false
		handle_attack()
	elif animation_player.current_animation == "fall":
		if velocity.y == 0:
			animation_player.play("idle")
	else:
		if velocity.y > 0 and !is_on_floor():
			animation_player.play("fall")
		elif velocity.y == 0 and is_on_floor():
			if is_moving_pressed():
				# start movement
				animation_player.play("move")
			elif Input.is_action_just_pressed("ui_accept"):
				handle_jump_fall()
			elif Input.is_action_just_pressed("attack"):
				handle_attack()
			else:
				animation_player.play("idle")
		else:
			pass
			#print("hold jump animation end frame")
		
		

func is_attacking() -> bool:
	var atks = ["atk1", "atk2"]
	return atks.has(animation_player.current_animation)

func is_jumping() -> bool:
	return (animation_player.current_animation == "jump" and !is_on_floor())

func is_moving_pressed() -> bool:
	return (Input.is_action_pressed("move_left") or \
	Input.is_action_pressed("move_right")) and \
	!(Input.is_action_pressed("move_left") and \
	Input.is_action_pressed("move_right"))

func handle_jump_fall():
	if !is_jumping():
		if !is_attacking() or \
		(velocity.y < 0 and (animation_player.current_animation == "idle" \
		or animation_player.current_animation == "move")):
			animation_player.play("jump")
			jumpTrigger = true
	else:
		if debugStop:
			pass
		if !is_on_floor() and velocity.y > 0:
			animation_player.play("fall")

func handle_attack():
	if !is_attacking() and is_on_floor():
		animation_player.play("atk1")
	else:
		if animation_player.current_animation == "atk1":
			if animation_player.current_animation_position >= 0.10 and \
			animation_player.current_animation_position < 0.25:
				if Input.is_action_just_pressed("attack"):
					#nextActionBuffered = true
					bufferedAction = "attack"
				elif Input.is_action_just_pressed("ui_accept"):
					bufferedAction = "jump"
			if animation_player.current_animation_position >= 0.25:
				if Input.is_action_just_pressed("attack") or bufferedAction == "attack":
					print("buffered action: " + bufferedAction)
					animation_player.play("atk2")
					bufferedAction = ""
				elif Input.is_action_just_pressed("ui_accept") or bufferedAction == "jump":
					print("buffered action: " + bufferedAction)
					animation_player.stop()
					handle_jump_fall()
					bufferedAction = ""
					debugStop = true
			if animation_player.current_animation_position >= 0.50:
				if is_moving_pressed():
					animation_player.play("move")
		elif animation_player.current_animation == "atk2":
			if animation_player.current_animation_position >= 0.50:
				if is_moving_pressed():
					animation_player.play("move")
				elif Input.is_action_just_pressed("ui_accept"):
					animation_player.stop()
					handle_jump_fall()
				
	

func flip_char(direction: String):
	if direction == "right":
		get_node("PlayerSprite").scale.x = 1
		get_node("PlayerSprite").position.x = 3
		get_node("Atk1HitBox/Atk1HitboxShape").position.x = absf(get_node("Atk1HitBox/Atk1HitboxShape").position.x)
		get_node("Atk2HitBox/Atk2HitboxShape").position.x = absf(get_node("Atk2HitBox/Atk2HitboxShape").position.x)
		get_node("Atk2HitBox/Atk2HitboxShape2").position.x = absf(get_node("Atk2HitBox/Atk2HitboxShape2").position.x)
	elif direction == "left":
		get_node("PlayerSprite").scale.x = -1
		get_node("PlayerSprite").position.x = -3
		get_node("Atk1HitBox/Atk1HitboxShape").position.x = -absf(get_node("Atk1HitBox/Atk1HitboxShape").position.x)
		get_node("Atk2HitBox/Atk2HitboxShape").position.x = -absf(get_node("Atk2HitBox/Atk2HitboxShape").position.x)
		get_node("Atk2HitBox/Atk2HitboxShape2").position.x = -absf(get_node("Atk2HitBox/Atk2HitboxShape2").position.x)

func get_hit(hitbox: HitBox):
	var parent = hitbox.get_parent()
	if parent != self:
		print("Player got attacked!")

