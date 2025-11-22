extends Node2D

@export var player_path: NodePath
@export var camera_path: NodePath
@export var npc_path: NodePath

@onready var player: Node = get_node(player_path)
@onready var cam: Camera2D = get_node(camera_path)
@onready var npc: Node = get_node(npc_path)
@onready var win_label: Label = $WinLabel

var playing: bool = false

func play_intro() -> void:
	if playing:
		return
	playing = true

	
	player.set_physics_process(false)

	
	await get_tree().create_timer(0.5).timeout
	npc.start_conversation()

	await get_tree().create_timer(2.0).timeout
	

	
	player.set_physics_process(true)
	playing = false


func play_win() -> void:
	if playing:
		return
	playing = true

	
	player.set_physics_process(false)

	
	win_label.text = "You win!"
	win_label.visible = true


func _on_button_pressed():
	get_tree().quit()


func _on_button_2_pressed():
	get_tree().change_scene_to_file("res://Scenes/main_menu.tscn")
