extends Node2D

@onready var cream_pie_container: Node2D = $CreamPieContainer
@onready var cooldown_timer: Timer = $CooldownTimer

var cream_pie_scene = preload("res://weapons/cream_pie_weapon_single.tscn")
var cream_pie_explosion_scene = preload("res://weapons/cream_pie_explosion.tscn")

var attacking := false

@export var explosion_radius := 15.0
@export var alive_time := 5.0
@export var cooldown_time := 5.0

func _ready() -> void:
	cooldown_timer.connect("timeout", cooldown_timer_timeout)
	visible = false
	add_pie()
	add_pie()
	add_pie()
	cooldown_timer.start(cooldown_time)

func add_pie() -> void:
	var new_pie = cream_pie_scene.instantiate()
	cream_pie_container.add_child(new_pie)
	new_pie.connect("explode", spawn_explosion)
	new_pie.visible = false
	new_pie.set_process(false)

func start_attack() -> void:
	visible = true
	attacking = true
	fire_pies()
	
func end_attack() -> void:
	visible = false
	attacking = false

func fire_pies() -> void:
	var cream_pies = cream_pie_container.get_children()
	var delay_timer_offset := 0.1
	for i in range(len(cream_pies)):
		cream_pies[i].set_process(true)
		cream_pies[i].visible = true
		cream_pies[i].delay_timer.start(delay_timer_offset)
		delay_timer_offset += 0.18

func cooldown_timer_timeout() -> void:
	if attacking:
		end_attack()
		cooldown_timer.start(cooldown_time)
	else:
		start_attack()
		cooldown_timer.start(alive_time)

func spawn_explosion(pos: Vector2) -> void:
	var new_explosion = cream_pie_explosion_scene.instantiate()
	add_child(new_explosion)
	new_explosion.fixed_position = pos
