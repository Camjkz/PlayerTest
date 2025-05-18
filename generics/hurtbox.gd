class_name Hurtbox
extends Area2D

@export var hurtboxArea : CollisionShape2D

func _init() -> void:
	collision_layer = 0
	collision_mask = 2

func _ready() -> void:
	connect("area_entered", _on_area_entered)
	
func _on_area_entered(hitbox: HitBox) -> void:
	if hitbox == null:
		return
	else:
		if owner.has_method("get_hit"):
			owner.get_hit(hitbox, self);
