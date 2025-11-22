extends CanvasLayer

@export var win_scene: PackedScene   

var score: int = 0

var max_lives: int = 3
var current_lives: int = 3

var initialized: bool = false

var score_label: Label
var life1: TextureRect
var life2: TextureRect
var life3: TextureRect

func _ready() -> void:
	print("HUD script is on node:", get_path())
	print("HUD children are:")
	for child in get_children():
		print(" - ", child.name)

	score_label = get_node_or_null("ScoreLabel")
	life1 = get_node_or_null("Life1")
	life2 = get_node_or_null("Life2")
	life3 = get_node_or_null("Life3")


	initialized = true

	_update_score_label()
	_update_lives()

func add_point(amount: int = 1) -> void:
	score += amount
	_update_score_label()
	_check_win()

func _update_score_label() -> void:
	if score_label:
		score_label.text = "Score: %d" % score

func _check_win() -> void:
	
	if score >= 5 and win_scene != null:
		get_tree().change_scene_to_packed(win_scene)


func set_lives(current: int, max_hp: int) -> void:
	current_lives = max(0, current)
	max_lives = max_hp
	if initialized:
		_update_lives()

func _update_lives() -> void:
	if life1:
		life1.visible = current_lives >= 1
	if life2:
		life2.visible = current_lives >= 2
	if life3:
		life3.visible = current_lives >= 3
