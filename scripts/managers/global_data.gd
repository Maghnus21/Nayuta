extends Node

## This script will be used to collect and house data any object can use
## scripts and objects will query this script for functions and data when necessary

"===============[Player Variables]==============="
var player

"===============[Player Flags]==============="
var is_player_in_dialogue:bool = false

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

## to be called by main scene root nodes upon loading into a game
func start_global_data():
	set_player();

func set_player():
	player = get_tree().get_first_node_in_group("player")
	print(self,": found player ", player, ", populatiing player field")

func get_player() -> Node3D:
	return player
