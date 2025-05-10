extends Node2D

@onready var pins: Node2D = $Pins
@onready var cool_down_timer: Timer = $CoolDownTimer

var pin_scene = preload("res://weapons/bowling_pin_weapon_single.tscn")
var time: float = 0.0
var radius: float = 50.0
var rotation_speed_deg: float = 5.0
var attacking: bool = false

@export var speed := 2.0
@export var cooldown_time := 5.0
@export var alive_time := 5.5
@export var damage := 1

func _ready() -> void:
	add_pin()
	Globals.connect("upgrade", upgrade)
	cool_down_timer.connect("timeout", cooldown_timer_timeout)
	cool_down_timer.start(cooldown_time)

func _process(delta: float) -> void:
	# delta is the amount of time taken to render the previous frame
	if attacking:
		var pin_weapons = pins.get_children()
		time += delta
		for pin in range(len(pin_weapons)):
			var angle = pin * ((2 * PI) / len(pin_weapons))
			pin_weapons[pin].position = Vector2(sin(angle + time * speed) * radius, cos(angle + time * speed) * radius)
			pin_weapons[pin].rotate(deg_to_rad(rotation_speed_deg))

func add_pin() -> void:
	end_attack()
	var new_pin = pin_scene.instantiate()
	pins.add_child(new_pin)
	new_pin.position = Vector2.ZERO
	new_pin.disable()
	new_pin.set_process(false)

func cooldown_timer_timeout() -> void:
	if attacking:
		end_attack()
		cool_down_timer.start(alive_time)
	else:
		start_attack()
		cool_down_timer.start(cooldown_time)

func start_attack():
	attacking = true
	# set initial position for each bowling pin
	var pin_weapons = pins.get_children()
	for pin in range(len(pin_weapons)):
		var angle = pin * ((2 * PI) / len(pin_weapons))
		pin_weapons[pin].position = Vector2(sin(angle) * radius, cos(angle) * radius)
		pin_weapons[pin].enable()
		pin_weapons[pin].damage = damage
		pin_weapons[pin].set_process(true)

func end_attack():
	attacking = false
	# disable all bowling pins
	var pin_weapons = pins.get_children()
	for pin in range(len(pin_weapons)):
		pin_weapons[pin].disable()
		pin_weapons[pin].position = Vector2.ZERO
		pin_weapons[pin].set_process(false)

func get_count() -> int:
	return pins.get_child_count()

func upgrade(upgrade) -> void:
	if not upgrade["upgrade"] == "bowling_pin": return
	
	end_attack()
	cool_down_timer.start(cooldown_time)
	match upgrade["level"]:
		2:
			add_pin()
			alive_time += 1.5
			damage += 1
		3:
			add_pin()
			cooldown_time -= 1.5
			damage += 1
		4:
			speed += 4
			alive_time += 1.5
			cooldown_time -= 1.5
			damage += 1
		5:
			add_pin()
			speed += 2
			damage += 1
	Globals.update_level("bowling_pin", upgrade["level"])
