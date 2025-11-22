extends CharacterBody2D

@export var speed: float = 200.0
@export var agro_range: float = 1000.0
@export var stop_distance: float = 50.0
@export var attack_cooldown: float = 1.0
@export var prompt_range: float = 250.0

var player: CharacterBody2D
var has_seen_player: bool = false
var attack_timer: float = 0.0

@onready var hit_area: Area2D = $HitArea
@onready var press_e: Label = $PressE

func _ready() -> void:
	add_to_group("enemy")
	player = get_tree().get_first_node_in_group("player") as CharacterBody2D
	if hit_area:
		hit_area.body_entered.connect(_on_HitArea_body_entered)
	press_e.visible = false

func _physics_process(delta: float) -> void:
	if player == null:
		return

	if attack_timer > 0.0:
		attack_timer -= delta
	if attack_timer < 0.0:
		attack_timer = 0.0

	var direction: Vector2 = player.global_position - global_position
	var distance: float = direction.length()

	if distance <= prompt_range:
		press_e.visible = true
	else:
		press_e.visible = false

	if distance <= agro_range:
		has_seen_player = true

	if not has_seen_player:
		velocity = Vector2.ZERO
		move_and_slide()
		return

	if distance > stop_distance:
		velocity = direction.normalized() * speed
	else:
		velocity = Vector2.ZERO

	move_and_slide()

func _on_HitArea_body_entered(body: Node) -> void:
	if attack_timer > 0.0:
		return

	if body.is_in_group("player") and body.has_method("take_damage"):
		var knockback_dir: Vector2 = (body.global_position - global_position).normalized()
		body.take_damage(1, knockback_dir)
		attack_timer = attack_cooldown

func die() -> void:
	queue_free()
