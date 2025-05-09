extends Node2D

@onready var hurt_box: Area2D = $HurtBox
@onready var collision_shape_2d: CollisionShape2D = $HurtBox/CollisionShape2D

var fixed_position := Vector2.ZERO
var damage := 5

func _ready() -> void:
	hurt_box.connect("area_entered", deal_damage)
	#collision_shape_2d.shape.radius = randf_range(20.0, 50.0)

func _process(delta: float) -> void:
	global_position = fixed_position

func deal_damage(body: Area2D) -> void:
	var target = body.get_parent()
	if target.has_method("hurt"):
		target.hurt(damage)
