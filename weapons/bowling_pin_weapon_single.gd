extends Node2D

# deals damage to ememies
@onready var hurt_box: Area2D = $HurtBox

var damage := 1

func _ready() -> void:
	hurt_box.connect("area_entered", deal_damage)

func deal_damage(body: Area2D) -> void:
	var target = body.get_parent()
	if target.has_method("hurt"):
		target.hurt(damage)

func enable() -> void:
	visible = true
	hurt_box.monitoring = true

func disable() -> void:
	visible = false
	hurt_box.monitoring = false
