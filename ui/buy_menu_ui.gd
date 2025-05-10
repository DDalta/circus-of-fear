extends Control

@onready var option_1_button: Button = $VBoxContainer/MarginContainer/VBoxContainer/Option1Button
@onready var option_2_button: Button = $VBoxContainer/MarginContainer/VBoxContainer/Option2Button
@onready var option_3_button: Button = $VBoxContainer/MarginContainer/VBoxContainer/Option3Button

@onready var buttons = [option_1_button, option_2_button, option_3_button]
var upgrades = []

func _ready() -> void:
	option_1_button.connect("pressed", call_upgrade.bind(0))
	option_2_button.connect("pressed", call_upgrade.bind(1))
	option_3_button.connect("pressed", call_upgrade.bind(2))

func open_menu() -> void:
	get_tree().paused = true
	upgrades = get_upgrades_menu()
	update_buttons()
	visible = true
	var tween: Tween = create_tween()
	tween.tween_property(self, "scale", Vector2(1.0, 1.0), 0.3)
	tween.play()

func close_menu() -> void:
	var tween: Tween = create_tween()
	tween.tween_property(self, "scale", Vector2(0.0, 1.0), 0.3)
	tween.play()
	visible = false

func update_buttons() -> void:
	for i in range(len(buttons)):
		if upgrades[i]["level"] == 1:
			buttons[i].text = "Equip " + str(upgrades[i]["upgrade"])
		else:
			buttons[i].text = "Upgrade " + str(upgrades[i]["upgrade"]) + " to level " + str(upgrades[i]["level"])

func get_upgrades_menu() -> Array:
	var new_upgrades = []
	
	# check current weapons for any available upgrades
	for weapon in Globals.equiped_weapons:
		if len(new_upgrades) > 2: break
		if weapon["level"] < 5:
			new_upgrades.append({"upgrade": weapon["weapon_name"], "level": weapon["level"] + 1})
	
	# check for potential new weapons to be equiped
	for weapon in Globals.weapons:
		if len(new_upgrades) > 2: break
		if check_equiped(weapon["weapon_name"]): continue
		new_upgrades.append({"upgrade": weapon["weapon_name"], "level": 1})
	
	if len(new_upgrades) < 3:
		for i in range(3 - len(new_upgrades)):
			new_upgrades.append({"upgrade": "health", "level": 5})
	
	return new_upgrades

func check_equiped(weapon_name: String) -> bool:
	for weapon in Globals.equiped_weapons:
		if weapon["weapon_name"] == weapon_name: return true
	return false

func call_upgrade(button_id: int) -> void:
	print(upgrades[button_id])
	Globals.upgrade.emit(upgrades[button_id])
	close_menu()
	get_tree().paused = false
