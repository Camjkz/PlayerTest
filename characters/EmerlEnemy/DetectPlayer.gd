extends Area2D

func _init():
	collision_mask = 4


# Called when the node enters the scene tree for the first time.
func _ready():
	connect("area_entered", _on_area_entered)
	connect("area_exited", _on_area_exited)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func _on_area_entered(hurtbox: Hurtbox):
	print(hurtbox.owner)

func _on_area_exited(hurtbox: Hurtbox):
	print(hurtbox.owner)
