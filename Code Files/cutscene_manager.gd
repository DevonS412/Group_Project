extends Node2D

@export var player_path: NodePath
@export var camera_path: NodePath
@export var npc_path: NodePath

@onready var player: Node = get_node(player_path)
@onready var cam: Camera2D = get_node(camera_path)
@onready var npc: Node = get_node(npc_path)

var playing: bool = false

func play_intro() -> void:
	if playing:
		return
	playing = true

	# lock player input
	player.set_physics_process(false)

	# simple sequence using coroutines
	await get_tree().create_timer(0.5).timeout
	npc.start_conversation()

	await get_tree().create_timer(2.0).timeout
	# you could move camera or player here if you want

	# end cutscene
	player.set_physics_process(true)
	playing = false

