extends Camera2D

@export var player: Node2D        
@export var move_distance := Vector2(1152, 648)

func _ready() -> void:
	make_current()  


func _physics_process(_delta: float) -> void:
	if player == null:
		return

	var player_pos = player.global_position
	var cam_pos = global_position
	var new_cam_pos = cam_pos

	
	if player_pos.x < cam_pos.x - move_distance.x / 2.0:
		new_cam_pos.x -= move_distance.x
	elif player_pos.x > cam_pos.x + move_distance.x / 2.0:
		new_cam_pos.x += move_distance.x

	
	if player_pos.y < cam_pos.y - move_distance.y / 2.0:
		new_cam_pos.y -= move_distance.y
	elif player_pos.y > cam_pos.y + move_distance.y / 2.0:
		new_cam_pos.y += move_distance.y

	if new_cam_pos != cam_pos:
		global_position = new_cam_pos

