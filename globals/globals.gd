extends Node

var run_time := 0.0
var current_level := 0
var experience_goal := 10.0
var current_experience := 0.0 :
	set(value):
		current_experience = value
		if current_experience >= experience_goal:
			current_level += 1
			current_experience = 0.0
			experience_goal = experience_goal * 2
			level_up.emit(current_level)

var weapons = [
	{"weapon_name": "bowling_pin", "scene": preload("res://weapons/bowling_pin_weapon.tscn"), "max_level": 5},
	{"weapon_name": "cannon", "scene": preload("res://weapons/cannon_weapon.tscn"), "max_level": 5},
	{"weapon_name": "cream_pie", "scene": preload("res://weapons/cream_pie_weapon.tscn"), "max_level": 5}
]

var equiped_weapons = [
	{"weapon_name": "bowling_pin", "level": 1}
]

signal level_up(level:int)
signal gain_experience(amount: int)
signal game_over()
signal upgrade(upgrade)

func _ready() -> void:
	self.connect("upgrade", add_weapon)
	self.connect("game_over", do_game_over)

func update_level(weapon_name, level) -> void:
	for weapon in equiped_weapons:
		if weapon["weapon_name"] == weapon_name:
			weapon["level"] = level
			break

func check_equiped(weapon_name: String) -> bool:
	for weapon in equiped_weapons:
		if weapon["weapon_name"] == weapon_name: return true
	return false

func get_weapon_from_name(weapon_name: String):
	for weapon in weapons:
		if weapon["weapon_name"] == weapon_name:
			return weapon["scene"]
	return null

func add_weapon(upgrade):
	if not check_equiped(upgrade["upgrade"]):
		var player = get_tree().get_first_node_in_group("player")
		var weapon_scene = get_weapon_from_name(upgrade["upgrade"])
		if weapon_scene:
			var new_weapon = weapon_scene.instantiate()
			player.equip_weapon(new_weapon)
			equiped_weapons.append({"weapon_name": upgrade["upgrade"], "level": 1})

func do_game_over():
	get_tree().quit()
