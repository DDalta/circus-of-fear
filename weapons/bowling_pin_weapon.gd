extends Node2D

# deals damage to ememies
@onready var hurt_box: Area2D = $HurtBox

var time: float = 0.0
var radius: float = 50.0
var speed: float = 2.0
var rotation_speed_deg: float = 5.0

@export var damage := 1

func _ready() -> void:
	hurt_box.connect("area_entered", deal_damage)

func _process(delta: float) -> void:
	# delta is the amount of time taken to render the previous frame
	time += delta
	position = Vector2(sin(time * speed) * radius, cos(time * speed) * radius)
	rotate(deg_to_rad(rotation_speed_deg))

func deal_damage(body: Area2D) -> void:
	pass
