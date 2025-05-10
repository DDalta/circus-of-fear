extends Node2D

@onready var cannon_ball_container: Node2D = $CannonBallContainer
@onready var cannon_ball_marker: Marker2D = $CannonBallMarker
@onready var cool_down_timer: Timer = $CoolDownTimer
@onready var fire_cannon_timer: Timer = $FireCannonTimer

var cannon_ball_scene = preload("res://weapons/cannon_ball_weapon.tscn")
var direction := 1
var attacking := false
var fixed_pos := Vector2.ZERO

@export var cooldown_time := 5.0
@export var alive_time := 5.0
@export var speed := 100
@export var damage := 1

func _ready() -> void:
	cool_down_timer.connect("timeout", cool_down_timer_timeout)
	fire_cannon_timer.connect("timeout", fire_cannon_timer_timeout)
	Globals.connect("upgrade", upgrade)
	end_attack()
	add_cannon_ball()
	cool_down_timer.start(cooldown_time)

func _process(delta: float) -> void:
	if attacking:
		global_position = fixed_pos

func add_cannon_ball() -> void:
	var new_ball = cannon_ball_scene.instantiate()
	cannon_ball_container.add_child(new_ball)
	new_ball.position = Vector2.ZERO

func start_attack() -> void:
	# pick random direction and fire
	if randf() < 0.5:
		direction = 1
		scale[0] = 1.0
	else:
		direction = -1
		scale[0] = -1.0
	
	fixed_pos = global_position + Vector2(50 * direction, 0)
	
	attacking = true
	visible = true
	
	# wait 1.5 seconds before firing cannon
	fire_cannon_timer.start(1.5)

func end_attack() -> void:
	visible = false
	attacking = false
	position = Vector2.ZERO

func fire_cannon() -> void:
	var cannon_balls = cannon_ball_container.get_children()
	for i in range(len(cannon_balls)):
		var angle = i * ((PI / 4) / len(cannon_balls))
		cannon_balls[i].enable(cannon_ball_marker.position, Vector2(direction, 0).rotated(angle))
		cannon_balls[i].damage = damage
		cannon_balls[i].speed = speed
		cannon_balls[i].set_process(true)

func cool_down_timer_timeout() -> void:
	if attacking:
		end_attack()
		cool_down_timer.start(cooldown_time)
	else:
		start_attack()
		cool_down_timer.start(alive_time)

func fire_cannon_timer_timeout() -> void:
	fire_cannon()

func upgrade(upgrade) -> void:
	if not upgrade["upgrade"] == "cannon": return
	
	end_attack()
	cool_down_timer.start(cooldown_time)
	match upgrade["level"]:
		2:
			add_cannon_ball()
			alive_time += 1.5
			damage += 1
		3:
			add_cannon_ball()
			cooldown_time -= 1.5
			damage += 1
		4:
			speed += 5
			alive_time += 1.5
			cooldown_time -= 1.5
			damage += 1
		5:
			add_cannon_ball()
			speed += 5
			damage += 1
	Globals.update_level("cannon", upgrade["level"])
