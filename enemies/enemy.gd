extends CharacterBody2D

@onready var distance_label: Label = $DistanceLabel

var target : CharacterBody2D
var speed: float = 15.0
var health: int = 10
var max_despawn_distance := 500

func _ready() -> void:
	target = get_tree().get_first_node_in_group("player")
	
func _process(delta: float) -> void:
	var direciton = global_position.direction_to(target.global_position)
	velocity = direciton.normalized() * speed
	
	var distance_from_player = global_position.distance_to(target.position)
	distance_label.text = str(round(distance_from_player))
	
	if distance_from_player >= max_despawn_distance:
		queue_free()
	
	move_and_slide()
