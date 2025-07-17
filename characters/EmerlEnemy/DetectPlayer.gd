extends Area2D

@onready var stateMachine : StateMachine = %EnemyStateMachine

@onready var detectedHurtbox : Hurtbox = null

func _init():
	collision_mask = 4


# Called when the node enters the scene tree for the first time.
func _ready():
	connect("area_entered", _on_area_entered)
	connect("area_exited", _on_area_exited)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if detectedHurtbox != null:
		owner.moveDirection = 1 if detectedHurtbox.hurtboxArea.global_position.x - global_position.x > 0 else -1


func _on_area_entered(hurtbox: Hurtbox):
	if hurtbox.owner.name.contains("Player"):
		owner.moveDirection = 1 if hurtbox.hurtboxArea.global_position.x - global_position.x > 0 else -1
		detectedHurtbox = hurtbox
		if stateMachine.currentState.name.contains("Idle"):
			stateMachine.on_child_transition(stateMachine.currentState, "EnemyMove")

func _on_area_exited(hurtbox: Hurtbox):
	if hurtbox.owner.name.contains("Player"):
		owner.moveDirection = 0
		detectedHurtbox = null
		if stateMachine.currentState.name == "EnemyMove":
			stateMachine.on_child_transition(stateMachine.currentState, "EnemyIdle")
