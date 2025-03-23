extends CharacterBody2D

@export var health: int = 10
@export var speed: int = 100
@export var attack_dmg: int
@export var defense: int
@export var pickup_rad: int

func _process(delta: float) -> void:
	var vertical = Input.get_axis("up", "down")
	var horizontal = Input.get_axis("left", "right")
	
	# TODO: add acceleration if movement is not smooth enough
	velocity = Vector2(horizontal, vertical).normalized() * speed
	move_and_slide()
