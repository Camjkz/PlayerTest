extends CharacterBody2D


@export var SPEED = 600.0
@export var JUMP_VELOCITY = -1000.0
@export var movespdModOnAtk = 0.3
@onready var animation_player: AnimationPlayer = %AnimationPlayer
@onready var player_statemachine: StateMachine = %PlayerStateMachine

# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity") * 3
var canFlip = true

# sus code
var bufferedAction = ""
var side = 1  # 1 = right, -1 = left
var jumpTrigger = false
var startFalling = true
var atk2move = false

func _physics_process(delta):
	pass
	#set_player_velocity(delta)
	#move_and_slide()

func _ready() -> void:
	side = get_node("PlayerSprite").scale.x
	#animation_player.play("idle")
	
func _process(delta):
	# handle orientation
	if canFlip:
		if Input.is_action_pressed("move_right") and !Input.is_action_pressed("move_left"):
			flip_char("right")
		elif Input.is_action_pressed("move_left") and !Input.is_action_pressed("move_right"):
			flip_char("left")


func is_attacking_ground() -> bool:
	return animation_player.current_animation.begins_with("atk")

func is_jumping() -> bool:
	return (animation_player.current_animation == "jump" and !is_on_floor())

func is_moving_pressed() -> bool:
	return (Input.is_action_pressed("move_left") or \
	Input.is_action_pressed("move_right")) and \
	!(Input.is_action_pressed("move_left") and \
	Input.is_action_pressed("move_right"))

func get_hit(hitbox: HitBox):
	var parent = hitbox.owner
	print(parent)
	if parent != self:
		print("Player got attacked!")


func set_char_velocity(_delta: float):
	# Add the gravity.
	if not is_on_floor():
		velocity.y += gravity * _delta

	# Handle jump.
	if jumpTrigger and is_on_floor() and !is_attacking_ground():
		velocity.y = JUMP_VELOCITY
		jumpTrigger = false

	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	var direction = Input.get_axis("move_left", "move_right")
	if direction:
		var prevVel = velocity
		velocity.x = direction * SPEED
		if is_attacking_ground():
			velocity = prevVel.lerp(Vector2(0, velocity.y), movespdModOnAtk)
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED/10)


func flip_char(direction: String):
	if direction == "right":
		get_node("PlayerSprite").scale.x = 1
		side = 1
	elif direction == "left":
		get_node("PlayerSprite").scale.x = -1
		side = -1


func _on_player_atk_lock_direction(lock: bool):
	canFlip = !lock


func _on_buffer_action(next: String):
	bufferedAction = next


func _on_player_jump_trigger():
	jumpTrigger = true
