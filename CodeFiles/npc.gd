extends CharacterBody2D

@export var speed: float = 150.0
@export var path_points: Array[Vector2] = []  
@export var dialog_lines: Array[String] = [
	"Whatup?",
	"If you wanna get outta here,",
	"Find and kill all the Enemies.",
	"Press E before they get too close!",
	"Good Luck!"
]

var current_point_index: int = 0
var player_in_range: bool = false
var is_talking: bool = false
var dialog_index: int = -1

@onready var talk_area: Area2D = $TalkArea
@onready var dialog_label: Label = $DialogLabel

func _ready() -> void:
	if path_points.is_empty():
		push_warning("NPC has no path_points!")
	else:
		global_position = path_points[0]

	dialog_label.text = ""

	talk_area.body_entered.connect(_on_talk_area_body_entered)
	talk_area.body_exited.connect(_on_talk_area_body_exited)

func _process(delta: float) -> void:
	
	if is_talking:
		if Input.is_action_just_pressed("talk"):
			_advance_dialog()
		return

	
	if player_in_range:
		dialog_label.text = "Press F to talk"
		if Input.is_action_just_pressed("talk"):
			_start_conversation()
			return
	else:
		dialog_label.text = ""

	
	if path_points.is_empty():
		return

	var target: Vector2 = path_points[current_point_index]
	global_position = global_position.move_toward(target, speed * delta)

	if global_position.distance_to(target) <= 1.0:
		current_point_index = (current_point_index + 1) % path_points.size()

func _start_conversation() -> void:
	if dialog_lines.is_empty():
		return

	is_talking = true
	dialog_index = 0
	dialog_label.text = dialog_lines[dialog_index]

func _advance_dialog() -> void:
	dialog_index += 1

	
	if dialog_index >= dialog_lines.size():
		is_talking = false
		dialog_index = -1

		#
		if player_in_range:
			dialog_label.text = "Press F to talk"
		else:
			dialog_label.text = ""
	else:
		dialog_label.text = dialog_lines[dialog_index]

func _on_talk_area_body_entered(body: Node) -> void:
	if body.is_in_group("player"):
		player_in_range = true
		if not is_talking:
			dialog_label.text = "Press F to talk"

func _on_talk_area_body_exited(body: Node) -> void:
	if body.is_in_group("player"):
		player_in_range = false
		if not is_talking:
			dialog_label.text = ""
