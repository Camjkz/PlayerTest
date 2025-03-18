extends CharacterBody2D

var gravity = ProjectSettings.get_setting("physics/2d/default_gravity") * 3

@export var slowdownMod : int = 60
@export var pushvelocityX : int = 600

@onready var hitknockbackX : int = 0
@onready var hitknockbackY : int = 0
@onready var canPush : bool = false
@onready var pushDirection : int = 1  # 1 = right, -1 = left
@onready var tumble : bool = false
@onready var hitstun : float = 0.0
@onready var side : int = 1
@onready var canFlip : bool = true

@onready var animPlayer : AnimationPlayer =  %AnimationPlayer
@onready var stateMachine : StateMachine = %EnemyStateMachine

# Called when the node enters the scene tree for the first time.
func _ready():
	pass


func _physics_process(delta):
	pass


func set_char_velocity(_delta: float):
	if not is_on_floor():
		velocity.y += gravity * _delta
	
	if hitknockbackX != 0 and canPush == false:
		velocity.x = hitknockbackX
		hitknockbackX = 0
	elif canPush == true:
		velocity.x = hitknockbackX + (pushvelocityX * pushDirection)
		hitknockbackX = 0
	else:
		if tumble:
			pass
			#velocity.x = move_toward(velocity.x, 0, slowdownMod)
		else:
			velocity.x = move_toward(velocity.x, 0, slowdownMod)
		
	if hitknockbackY != 0:
		velocity.y = hitknockbackY
		hitknockbackY = 0


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
	

func get_hit(hitbox: HitBox):
	var parent = hitbox.owner
	var atkparent = hitbox.get_parent()
	if parent != self:
		print("Attack detected")
		hitstun = hitbox.hitstun
		hitknockbackX = hitbox.knockbackX * parent.side
		hitknockbackY = hitbox.knockbackY
		
		var chosenHitState = "EnemyHitGrounded"
		if abs(hitknockbackX) < abs(hitknockbackY)/2:
			tumble = true
			if hitknockbackY < 0:
				chosenHitState = "EnemyHitUp"
			elif hitknockbackY > 0:
				chosenHitState = "EnemyHitDown"
		elif abs(hitknockbackX) > abs(hitknockbackY)/2:
			tumble = true
			chosenHitState = "EnemyHitAway"
			if hitknockbackX > 0:
				flip_char("left")
			elif hitknockbackX < 0:
				flip_char("right")
		
		stateMachine.on_child_transition(stateMachine.currentState, chosenHitState)
		

func flip_char(direction: String):
	if direction == "right":
		get_node("CharSprite").scale.x = 1
		side = 1
	elif direction == "left":
		get_node("CharSprite").scale.x = -1
		side = -1


func _on_push_area_entered(area : Area2D):
	if area.owner is CharacterBody2D:
		canPush = true
		var locX : float = area.owner.position.x
		if locX > self.position.x:
			pushDirection = -1
		elif locX < self.position.x:
			pushDirection = 1
		else:
			pass


func _on_push_area_exited(area):
	canPush = false
