extends ShapeCast2D

var lighthit = preload("res://effects/LightHit.tscn")
var hit = 0

func _init():
	collision_mask = 2

# Called when the node enters the scene tree for the first time.
func _ready():
	Hitvfx.finishAnim.connect(on_finish_hit_vfx)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if hit == 0:
		if is_colliding():
			var colx = get_collision_point(0).x
			var coly = get_collision_point(0).y
			print(get_collision_point(0))
			var lighthitvfx = lighthit.instantiate()
			add_child(lighthitvfx)
			hit = 1
			lighthitvfx.position.x = 0
			lighthitvfx.position.y = 0
	elif hit == 1:
		if !is_colliding():
			hit = 0

func on_finish_hit_vfx(hitvfx : Node2D):
	remove_child(hitvfx)
