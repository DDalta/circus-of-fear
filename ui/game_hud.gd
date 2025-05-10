extends CanvasLayer

@onready var xp_progress_bar: ProgressBar = $VBoxContainer/XPBar/XPProgressBar
@onready var level_label: Label = $VBoxContainer/XPBar/LevelLabel
@onready var buy_menu_ui: Control = $BuyMenuUI

func _ready() -> void:
	xp_progress_bar.value = 0.0
	Globals.connect("gain_experience", gain_experience)
	Globals.connect("level_up", level_up)
	
func gain_experience() -> void:
	xp_progress_bar.value = (Globals.current_experience / Globals.experience_goal) * 100

func level_up(level) -> void:
	xp_progress_bar.value = 0.0
	level_label.text = "LV. " + str(level)
	buy_menu_ui.open_menu()
	
