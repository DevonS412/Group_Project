extends Area2D

@export var target_scene: PackedScene
@export var target_spawn_point_name: String = "PlayerSpawn"

func _on_body_entered(body: Node2D) -> void:
	if not body.is_in_group("player"):
		return

	if target_scene == null:
		return

	var new_scene: Node = target_scene.instantiate()
	var tree := get_tree()
	tree.current_scene.free()
	tree.root.add_child(new_scene)
	tree.current_scene = new_scene

	var spawn: Node2D = new_scene.get_node_or_null(target_spawn_point_name)
	if spawn:
		body.global_position = spawn.global_position
