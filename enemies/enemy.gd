extends CharacterBody2D

@onready var debug_label: Label = $DebugLabel
# detects when weapon objects collides
@onready var hit_box: Area2D = $HitBox
@onready var invinsible_timer: Timer = $InvinsibleTimer

var target : CharacterBody2D
var speed: float = 18.0
var health: int = 2
var max_despawn_distance := 500
var invinsible: bool = false

func _ready() -> void:
	target = get_tree().get_first_node_in_group("player")
	invinsible_timer.connect("timeout", invinsible_timer_timeout)
	
func _process(delta: float) -> void:
	var direciton = global_position.direction_to(target.global_position)
	velocity = direciton.normalized() * speed
	
	var distance_from_player = global_position.distance_to(target.position)
	debug_label.text = str(health)
	
	if distance_from_player >= max_despawn_distance:
		queue_free()
	
	move_and_slide()

func flash() -> void:
	pass

func hurt(damage: int) -> void:
	if invinsible: return
	health -= damage
	invinsible = true
	if health <= 0:
		queue_free()
	invinsible_timer.start(0.5)

func invinsible_timer_timeout() -> void:
	invinsible = false
