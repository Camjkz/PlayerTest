extends CharacterBody2D

var gravity = ProjectSettings.get_setting("physics/2d/default_gravity") * 3


@onready var hitknockbackX : int = 0
@onready var hitknockbackY : int = 0
@onready var canPush : bool = false
@onready var pushDirection : int = 1  # 1 = right, -1 = left
@onready var tumble : bool = false
@export var slowdownMod : int = 60
@export var pushvelocityX : int = 600

@onready var animPlayer : AnimationPlayer =  %AnimationPlayer
@onready var stateMachine : StateMachine = %EnemyStateMachine

# Called when the node enters the scene tree for the first time.
func _ready():
	pass


func _physics_process(delta):
	pass
	#if not is_on_floor():
		#velocity.y += gravity * delta
	#
	#if hitknockbackX != 0 and canPush == false:
		#velocity.x = hitknockbackX
		#hitknockbackX = 0
	#elif canPush == true:
		#velocity.x = hitknockbackX + (pushvelocityX * pushDirection)
		#hitknockbackX = 0
	#else:
		#velocity.x = move_toward(velocity.x, 0, slowdownMod)
		#
	#if hitknockbackY != 0:
		#velocity.y = hitknockbackY
		#hitknockbackY = 0
		#
	#
	#move_and_slide()


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
		velocity.x = move_toward(velocity.x, 0, slowdownMod)
		
	if hitknockbackY != 0:
		velocity.y = hitknockbackY
		hitknockbackY = 0


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
	#if gotHit:
		#gotHit = false
		#if abs(velocity.y) > abs(velocity.x):
			#animPlayer.play("knockback_up")
	#else:
		#if is_on_floor():
			#animPlayer.play("idle")
	

func get_hit(hitbox: HitBox):
	var parent = hitbox.owner
	if parent != self:
		print("Attack detected")
		#gotHit = true
		hitknockbackX = hitbox.knockbackX * parent.side
		hitknockbackY = hitbox.knockbackY
		
		var chosenHitState = "EnemyHitGrounded"
		if abs(hitknockbackX) < abs(hitknockbackY):
			tumble = true
			if hitknockbackY < 0:
				chosenHitState = "EnemyHitUp"
			elif hitknockbackY > 0:
				chosenHitState = "EnemyHitDown"
		
		stateMachine.on_child_transition(stateMachine.currentState, chosenHitState)
		
		


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
