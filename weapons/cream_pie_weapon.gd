extends Node2D

@onready var sprite_2d: Sprite2D = $Sprite2D

const gravity: float = 9.8
var time: float = 0.0
var initial_speed: float
var throw_angle_degrees: float

var initial_position: Vector2
var throw_direction: Vector2

var z_axis = 0.0
var is_throw: bool = false

func _process(delta: float) -> void:
	time += delta * 10
	
	if Input.is_action_just_pressed("ui_accept"):
		throw_projectile(global_position, Vector2(1, 0), 100, 75)
		
	if is_throw:
		# get y position at time t 
		z_axis = initial_speed * sin(deg_to_rad(throw_angle_degrees)) * time - 0.5 * gravity * pow(time, 2)
		
		# if hasn't touched ground yet
		if z_axis > 0:
			# get x position at time t
			var x_axis: float = initial_speed * cos(deg_to_rad(throw_angle_degrees)) * time
			# update x-axis
			global_position = initial_position + throw_direction * x_axis
			# update y-axis
			sprite_2d.position.y = -z_axis

# setup projectile before throwing
func throw_projectile(initial_pos: Vector2, direction: Vector2, distance: float, angle_degree: float):
	initial_position = initial_pos
	throw_direction = direction.normalized()
	throw_angle_degrees = angle_degree
	
	# get initial speed from the desired distance and desired angle
	initial_speed = pow(distance * gravity / sin(2 * deg_to_rad(angle_degree)), 0.5)
	
	global_position = initial_position
	time = 0.0
	is_throw = true
