extends CharacterBody2D

@export var speed: float = 120.0

var attacking: bool = false
var facing_dir: Vector2 = Vector2.DOWN

@onready var anim: AnimationPlayer = $AnimationPlayer

func _physics_process(delta: float) -> void:
	if attacking:
		velocity = Vector2.ZERO
		move_and_slide()
		return

	var input_vector := Vector2.ZERO
	input_vector.x = Input.get_action_strength("ui_right") - Input.get_action_strength("ui_left")
	input_vector.y = Input.get_action_strength("ui_down") - Input.get_action_strength("ui_up")
	input_vector = input_vector.normalized()

	velocity = input_vector * speed
	move_and_slide()

	if input_vector != Vector2.ZERO:
		facing_dir = input_vector
		_play_move_anim(input_vector)
	else:
		_play_idle_anim()

	if Input.is_action_just_pressed("attack"):
		_attack()

func _play_move_anim(dir: Vector2) -> void:
	if abs(dir.x) > abs(dir.y):
		if dir.x > 0:
			anim.play("walk_right")
		else:
			anim.play("walk_left")
	else:
		if dir.y > 0:
			anim.play("walk_down")
		else:
			anim.play("walk_up")

func _play_idle_anim() -> void:
	# assumes idle animations exist with these names
	match facing_dir:
		Vector2.RIGHT:
			anim.play("idle_right")
		Vector2.LEFT:
			anim.play("idle_left")
		Vector2.UP:
			anim.play("idle_up")
		_:
			anim.play("idle_down")

func _attack() -> void:
	attacking = true
	if facing_dir == Vector2.RIGHT:
		anim.play("attack_right")
	elif facing_dir == Vector2.LEFT:
		anim.play("attack_left")
	elif facing_dir == Vector2.UP:
		anim.play("attack_up")
	else:
		anim.play("attack_down")

func _on_AnimationPlayer_animation_finished(name: StringName) -> void:
	if name.begins_with("attack_"):
		attacking = false
