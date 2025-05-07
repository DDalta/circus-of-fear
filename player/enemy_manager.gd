extends Node

@export var enemy_spawn_radius := 300
@export var max_enemies_count := 200
@export var enemies: Array[PackedScene]

@onready var spawn_timer: Timer = $Timer

var player : CharacterBody2D

func _ready() -> void:
	player = get_tree().get_first_node_in_group("player")
	spawn_timer.connect("timeout", on_spawn_timer_timeout)
	spawn_timer.start(3.5)

func get_random_spawn() -> Vector2:
	var player_pos = player.global_position
	var angle = 2 * PI * randf()
	var x = player_pos[0] + enemy_spawn_radius * cos(angle)
	var y = player_pos[1] + enemy_spawn_radius * sin(angle)
	
	return Vector2(x, y)

func on_spawn_timer_timeout():
	var enemy_scene = enemies.pick_random()
	var enemy = enemy_scene.instantiate()
	add_child(enemy)
	enemy.global_position = get_random_spawn()
	spawn_timer.start(1.0)
