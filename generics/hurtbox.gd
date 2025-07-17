class_name Hurtbox
extends Area2D

@export var hurtboxArea : CollisionShape2D

@onready var lastGroupCollision = ""

func _init() -> void:
	collision_layer = 4
	collision_mask = 2

func _ready() -> void:
	connect("area_entered", _on_area_entered)
	connect("area_exited", _on_area_exited)
	
func _on_area_entered(hitbox: HitBox) -> void:
	if hitbox == null:
		return
	else:
		var allowHit = true;
		if owner.has_method("get_hit") and hitbox.owner != owner:
			if "projectileOwner" in hitbox.owner:
				if hitbox.owner.projectileOwner == owner:
					return
			if hitbox.isGrouped:
				if lastGroupCollision == hitbox.groupName:
					allowHit = false;
				if lastGroupCollision == "":
					lastGroupCollision = hitbox.groupName
			if allowHit:	
				owner.get_hit(hitbox, self);

func _on_area_exited(hitbox: HitBox) -> void:
	lastGroupCollision = ""
