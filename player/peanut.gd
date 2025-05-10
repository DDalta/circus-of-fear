extends Area2D

var value := 1

func _ready() -> void:
	connect("body_entered", player_pickedup)
	
func player_pickedup(_body) -> void:
	Globals.current_experience += value
	Globals.gain_experience.emit()
	queue_free()
