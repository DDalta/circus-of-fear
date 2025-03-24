extends Node2D

var time: float = 0.0
var radius: float = 50.0
var speed: float = 2.0
var rotation_speed_deg: float = 5.0

func _process(delta: float) -> void:
	# delta is the amount of time taken to render the previous frame
	time += delta
	position = Vector2(sin(time * speed) * radius, cos(time * speed) * radius)
	rotate(deg_to_rad(rotation_speed_deg))
