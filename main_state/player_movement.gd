extends CharacterBody2D


@export var SPEED = 300.0
@export var JUMP_VELOCITY = -400.0
@export var movespdModOnAtk = 0.5
@onready var animation_player = %AnimationPlayer

# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")


func _physics_process(delta):
	# Add the gravity.
	if not is_on_floor():
		velocity.y += gravity * delta

	# Handle jump.
	if Input.is_action_just_pressed("ui_accept") and is_on_floor() and animation_player.current_animation != "atk1":
		velocity.y = JUMP_VELOCITY

	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	var direction = Input.get_axis("move_left", "move_right")
	if direction:
		velocity.x = direction * SPEED
		if animation_player.current_animation == "atk1":
			velocity.x = velocity.x * movespdModOnAtk
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)

	move_and_slide()

func _process(delta):
	# choose animation, flip based on direction
	if Input.is_action_just_pressed("ui_accept") and is_on_floor() and animation_player.current_animation != "atk1":
		animation_player.play("jump")
	elif Input.is_action_just_pressed("attack") and is_on_floor():
		animation_player.play("atk1")
	if Input.is_action_pressed("move_right") and animation_player.current_animation != "atk1":
		if not Input.is_action_pressed("move_left"):
			get_node("PlayerSprite").scale.x = 1
			get_node("PlayerSprite").position.x = 3
			get_node("Atk1HitBox/Atk1HitboxShape").position.x = 14.4
			if is_on_floor() and animation_player.current_animation != "jump":
				animation_player.play("move")
		else:
			if is_on_floor() and animation_player.current_animation != "jump":
				animation_player.play("idle")
	elif Input.is_action_pressed("move_left") and animation_player.current_animation != "atk1":
		if not Input.is_action_pressed("move_right"):
			get_node("PlayerSprite").scale.x = -1
			get_node("PlayerSprite").position.x = -3
			get_node("Atk1HitBox/Atk1HitboxShape").position.x = -14.4
			if is_on_floor() and animation_player.current_animation != "jump":
				animation_player.play("move")
		else:
			if is_on_floor() and animation_player.current_animation != "jump":
				animation_player.play("idle")
	else:
		if animation_player.current_animation != "atk1" and animation_player.current_animation != "jump" and is_on_floor() and velocity.x == 0:
			animation_player.play("idle")
	if velocity.y > 0 and animation_player.current_animation != "fall":
		animation_player.play("fall")
