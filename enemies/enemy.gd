extends CharacterBody2D

var target : CharacterBody2D
var speed: float = 15.0

func _ready() -> void:
	target = get_tree().get_first_node_in_group("player")
	
func _process(delta: float) -> void:
	var direciton = global_position.direction_to(target.global_position)
	velocity = direciton.normalized() * speed
	move_and_slide()
