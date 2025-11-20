extends Node2D

@export var player_path: NodePath
@export var hud_path: NodePath

@onready var player = get_node(player_path)
@onready var hud   = get_node(hud_path)

var max_health: int = 3
var health: int = max_health
var rupees: int = 0

func _ready() -> void:
	# initialize HUD at start
	hud.update_health(health, max_health)
	hud.update_rupees(rupees)
	hud.show_message("Welcome, hero!")

# Call this when player picks up rupees
func add_rupees(amount: int) -> void:
	rupees += amount
	hud.update_rupees(rupees)

# Call this when an enemy hits the player
func damage_player(amount: int) -> void:
	if health <= 0:
		return
	health -= amount
	if health < 0:
		health = 0
	hud.update_health(health, max_health)
	hud.show_message("Ouch!")

	if health == 0:
		game_over()

func heal_player(amount: int) -> void:
	health += amount
	if health > max_health:
		health = max_health
	hud.update_health(health, max_health)

func game_over() -> void:
	hud.show_message("Game Over")
	# optional: stop player movement
	if player.has_method("set_physics_process"):
		player.set_physics_process(false)
