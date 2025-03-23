extends CharacterBody2D

@export var health: int = 10
@export var speed: int = 100
@export var damage: int # might not need since weapons will have their own damage attribute 
@export var defense: int
@export var pickup_radius: int

func _process(delta: float) -> void:
	var vertical = Input.get_axis("up", "down")
	var horizontal = Input.get_axis("left", "right")
	
	velocity = Vector2(horizontal, vertical).normalized() * speed
	move_and_slide()
