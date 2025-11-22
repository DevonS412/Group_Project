extends CharacterBody2D

@onready var sprite = $sprite

var speed: float = 600.0
var character_direction: Vector2 = Vector2.ZERO
var hit_range: float = 150.0

@export var hud: CanvasLayer
@export var max_health: int = 3
@export var game_over_scene: PackedScene

var current_health: int
var invincible_time: float = 0.5
var invincible_timer: float = 0.0

var knockback_duration: float = 0.15
var knockback_timer: float = 0.0

func _ready() -> void:
	current_health = max_health
	add_to_group("player")
	if hud != null and hud.has_method("set_lives"):
		hud.set_lives(current_health, max_health)

func _physics_process(delta: float) -> void:
	if invincible_timer > 0.0:
		invincible_timer -= delta

	if knockback_timer > 0.0:
		knockback_timer -= delta
		move_and_slide()
		return

	character_direction.x = Input.get_axis("walk_left", "walk_right")
	character_direction.y = Input.get_axis("walk_up", "walk_down")

	if character_direction != Vector2.ZERO:
		character_direction = character_direction.normalized()
		velocity = character_direction * speed
	else:
		velocity = Vector2.ZERO

	move_and_slide()

	if character_direction.x > 0:
		sprite.flip_h = true
	elif character_direction.x < 0:
		sprite.flip_h = false

	if Input.is_action_just_pressed("hit"):
		attack()

func attack() -> void:
	var area := RectangleShape2D.new()
	area.extents = Vector2(hit_range, hit_range)

	var query := PhysicsShapeQueryParameters2D.new()
	query.shape = area
	query.transform = Transform2D(0.0, global_position)
	query.collide_with_bodies = true
	query.collide_with_areas = false
	query.collision_mask = 2

	var space_state := get_world_2d().direct_space_state
	var results := space_state.intersect_shape(query)

	for result in results:
		var collider = result.collider
		if collider != null and collider.is_in_group("enemy"):
			if collider.has_method("die"):
				collider.die()
				if hud != null and hud.has_method("add_point"):
					hud.add_point(1)

func take_damage(amount: int, knockback_dir: Vector2 = Vector2.ZERO) -> void:
	if invincible_timer > 0.0:
		return

	if knockback_dir != Vector2.ZERO:
		velocity = knockback_dir.normalized() * 600.0
		knockback_timer = knockback_duration

	current_health -= amount
	invincible_timer = invincible_time

	if hud != null and hud.has_method("set_lives"):
		hud.set_lives(current_health, max_health)

	if current_health <= 0:
		die()

func die() -> void:
	if game_over_scene != null:
		get_tree().change_scene_to_packed(game_over_scene)
	else:
		get_tree().quit()
