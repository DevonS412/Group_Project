extends CharacterBody2D

@export var speed: float = 60.0
@export var patrol_points: Array[Vector2] = []
var current_point_index: int = 0

func _ready() -> void:
	if patrol_points.size() > 0:
		global_position = patrol_points[0]

func _physics_process(delta: float) -> void:
	if patrol_points.size() == 0:
		return

	var target: Vector2 = patrol_points[current_point_index]
	var dir: Vector2 = (target - global_position).normalized()
	velocity = dir * speed
	move_and_slide()

	if global_position.distance_to(target) < 4.0:
		current_point_index = (current_point_index + 1) % patrol_points.size()
