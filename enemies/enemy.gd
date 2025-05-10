extends CharacterBody2D

@onready var debug_label: Label = $DebugLabel
# detects when weapon objects collides
@onready var hit_box: Area2D = $HitBox
@onready var invinsible_timer: Timer = $InvinsibleTimer
@onready var hurt_box: Area2D = $HurtBox
@onready var sprite_2d: Sprite2D = $Sprite2D

var peanut_scene = preload("res://player/peanut.tscn")

var target : CharacterBody2D
var speed: float = 18.0
var health: int = 2
var max_despawn_distance := 500
var invinsible: bool = false
var damage := 5

func _ready() -> void:
	target = get_tree().get_first_node_in_group("player")
	invinsible_timer.connect("timeout", invinsible_timer_timeout)
	hurt_box.connect("body_entered", deal_damage)
	
func _process(delta: float) -> void:
	var direciton = global_position.direction_to(target.global_position)
	velocity = direciton.normalized() * speed
	
	if velocity.x > 0.0:
		sprite_2d.scale = Vector2(0.438, 0.438)
	elif velocity.x < 0.0:
		sprite_2d.scale = Vector2(-0.438, 0.438)
	
	var distance_from_player = global_position.distance_to(target.position)
	if distance_from_player >= max_despawn_distance:
		queue_free()
	
	move_and_slide()

func flash() -> void:
	pass

func drop_peanut() -> void:
	var new_peanut = peanut_scene.instantiate()
	get_tree().current_scene.add_child(new_peanut)
	new_peanut.global_position = global_position

func hurt(damage: int) -> void:
	if invinsible: return
	health -= damage
	invinsible = true
	if health <= 0:
		drop_peanut()
		queue_free()
	invinsible_timer.start(0.5)

func deal_damage(body):
	if body.has_method("hurt"):
		body.hurt(damage)

func invinsible_timer_timeout() -> void:
	invinsible = false
