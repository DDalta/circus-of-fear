extends CharacterBody2D

@onready var invinsible_timer: Timer = $InvinsibleTimer
@onready var health_bar: ProgressBar = $HealthBar
@onready var hit_box: Area2D = $HitBox
@onready var sprite_2d: Sprite2D = $Sprite2D
@onready var weapons: Node2D = $Weapons
@onready var animation_player: AnimationPlayer = $AnimationPlayer

@export var max_health: float = 25.0
@export var speed: int = 100
@export var damage: int # might not need since weapons will have their own damage attribute 
@export var defense: int
@export var pickup_radius: int

var invinsible := false
var current_health := max_health

func _ready() -> void:
	invinsible_timer.connect("timeout", invinsible_timer_timeout)

func _process(delta: float) -> void:
	var vertical = Input.get_axis("up", "down")
	var horizontal = Input.get_axis("left", "right")
	
	velocity = Vector2(horizontal, vertical).normalized() * speed
	if velocity.x > 0.0:
		animation_player.play("walk")
		sprite_2d.scale = Vector2(-0.328, 0.328)
	elif velocity.x < 0.0:
		animation_player.play("walk")
		sprite_2d.scale = Vector2(0.328, 0.328)
	else:
		animation_player.play("RESET")
	move_and_slide()

func hurt(damage_amount: float) -> void:
	if not invinsible:
		current_health -= damage_amount
		health_bar.value = (current_health / max_health) * 100
		invinsible = true
		invinsible_timer.start(0.6)
		if current_health <= 0:
			# dead as hell
			Globals.game_over.emit()
		
func invinsible_timer_timeout() -> void:
	invinsible = false

func equip_weapon(weapon) -> void:
	weapons.add_child(weapon)
