extends Area2D

@onready var npc = get_parent()

func _on_body_entered(body: Node2D) -> void:
	if body.is_in_group("player"):
		set_process_input(true)

func _on_body_exited(body: Node2D) -> void:
	if body.is_in_group("player"):
		set_process_input(false)

func _input(event: InputEvent) -> void:
	if event.is_action_pressed("interact"):
		npc.start_conversation()

