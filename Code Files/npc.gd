extends CharacterBody2D

@export var speed: float = 40.0
@export var path_points: Array[Vector2] = []
@export var dialog_lines: Array[String] = [
	"Welcome, hero.",
	"The forest is dangerous ahead.",
	"Find the key in the cave."
]

var current_point_index: int = 0
var talking: bool = false

signal npc_talk(line: String)

func _ready() -> void:
	if path_points.size() > 0:
		global_position = path_points[0]

func _physics_process(delta: float) -> void:
	if talking or path_points.size() == 0:
		velocity = Vector2.ZERO
		move_and_slide()
		return

	var target := path_points[current_point_index]
	var dir := (target - global_position).normalized()
	velocity = dir * speed
	move_and_slide()

	if global_position.distance_to(target) < 4.0:
		current_point_index = (current_point_index + 1) % path_points.size()

func start_conversation() -> void:
	talking = true
	for line in dialog_lines:
		npc_talk.emit(line)
	talking = false
