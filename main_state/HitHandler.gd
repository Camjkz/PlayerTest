extends Node

var lighthit = preload("res://effects/LightHit.tscn")

# Called when the node enters the scene tree for the first time.
func _ready():
	Hitvfx.connect("showHit", _on_show_hit)
	Hitvfx.finishAnim.connect(on_finish_hit_vfx)


func _on_show_hit(hitbox: HitBox, hurtbox: Hurtbox):
	#print(hitbox.hitboxArea.global_position)
	#print(hurtbox.hurtboxArea.global_position)
	var lighthitvfx = lighthit.instantiate()
	add_child(lighthitvfx)
	lighthitvfx.global_position = (hitbox.hitboxArea.global_position + hurtbox.hurtboxArea.global_position) / 2
	#print(lighthitvfx.global_position)


func on_finish_hit_vfx(hitvfx : Node2D):
	remove_child(hitvfx)
