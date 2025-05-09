extends Node2D

@onready var hurt_box: Area2D = $HurtBox

var direction := 1
var speed := 100
var damage := 1
var attacking := false

func _ready() -> void:
	hurt_box.connect("area_entered", deal_damage)
	visible = false
	hurt_box.monitoring = false
	set_process(false)

func _process(delta: float) -> void:
	if attacking:
		global_position[0] += ((direction * speed) * delta)

func enable(pos, dir) -> void:
	visible = true
	hurt_box.monitoring = true
	direction = dir
	position = pos
	attacking = true
	
func disable() -> void:
	visible = false
	hurt_box.monitoring = false
	position = Vector2.ZERO
	attacking = false
	set_process(false)

func deal_damage(body: Area2D) -> void:
	var target = body.get_parent()
	if target.has_method("hurt"):
		target.hurt(damage)
