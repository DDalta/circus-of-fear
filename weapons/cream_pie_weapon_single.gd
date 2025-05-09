extends Node2D

@onready var sprite_2d: Sprite2D = $Sprite2D
@onready var delay_timer: Timer = $DelayTimer

const gravity: float = 9.8
var time: float = 0.0
var initial_speed: float
var throw_angle_degrees: float
var initial_position: Vector2
var throw_direction: Vector2
var y_axis: float = 0.0
var is_throw: bool = false

signal explode(pos)

func _ready() -> void:
	delay_timer.connect("timeout", delay_timer_timeout)

func _process(delta: float) -> void:
	time += delta * 10
	
	#if Input.is_action_just_pressed("ui_accept"):
		#throw_projectile(global_position, Vector2(1, 0), 100, 75)
		
	if is_throw:
		var prev_y_axis: float = y_axis
		# get y position at time t 
		y_axis = initial_speed * sin(deg_to_rad(throw_angle_degrees)) * time - 0.5 * gravity * pow(time, 2)
		
		# check when pie just landed on ground
		if y_axis <= 0 and prev_y_axis > 0:
			is_throw = false
			#TODO: explode pie when it lands
			explode.emit(global_position)
			position = Vector2.ZERO
			set_process(false)
		
		# if hasn't touched ground yet, update position
		if y_axis > 0:
			# get x position at time t
			var x_axis: float = initial_speed * cos(deg_to_rad(throw_angle_degrees)) * time
			# update x-axis
			global_position = initial_position + (throw_direction * x_axis)
			# update y-axis
			sprite_2d.position.y = -y_axis

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

func delay_timer_timeout() -> void:
	var direction = 1 if randf() < 0.5 else -1
	var distance = randi_range(100, 200)
	throw_projectile(global_position, Vector2(direction, 0), distance, 75)
