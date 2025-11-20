extends Camera2D

@export var player_path: NodePath
var player: Node2D

# distance the camera moves when player crosses edge of screen
var move_distance: Vector2 = Vector2.ZERO

func _ready() -> void:
	player = get_node(player_path)
	set_as_top_level(true)
	# 1152x648 example – change to match your viewport size
	move_distance = Vector2(1152, 648) / zoom

func _physics_process(delta: float) -> void:
	var player_pos: Vector2 = player.global_position
	var cam_pos: Vector2 = global_position
	var new_cam_pos: Vector2 = cam_pos

	# horizontal edges
	if player_pos.x < cam_pos.x - move_distance.x / 2.0:
		new_cam_pos.x -= move_distance.x
	elif player_pos.x > cam_pos.x + move_distance.x / 2.0:
		new_cam_pos.x += move_distance.x

	# vertical edges
	if player_pos.y < cam_pos.y - move_distance.y / 2.0:
		new_cam_pos.y -= move_distance.y
	elif player_pos.y > cam_pos.y + move_distance.y / 2.0:
		new_cam_pos.y += move_distance.y

	global_position = new_cam_pos
