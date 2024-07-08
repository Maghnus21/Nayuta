extends Node

## This script will be used to collect and house data any object can use
## scripts and objects will query this script for functions and data when necessary
## To access via script, add "GlobalData" and the "." syntax to access functions and variables

enum  NODE_GROUP {holdable}
var node_group_dict = {0:"holdable"}

"===============[Player Variables]==============="
var player
var player_has_died:bool = false
var entity_in_dialogue_sequence:Node3D

"===============[Player Flags]==============="
var is_player_in_dialogue:bool = false

"===============[Level Variables]============"
var e1m1_craimg_count:int = 26
var e1m1_craimh_death:int = 0
var e1m1_all_craimh_dead:bool = false

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

## to be called by main scene root nodes upon loading into a game
func start_global_data():
	set_player()

func set_player():
	player = get_tree().get_first_node_in_group("player")
	print(self,": found player ", player, ", populatiing player field")

func get_player() -> Node3D:
	return player

func e1m1_update_craimh_death_count(amount:int):
	e1m1_craimh_death += amount
	
	var new_text:String = "Cnaimh remaining:\n" + str(e1m1_craimg_count-e1m1_craimh_death) + " / " + str(e1m1_craimg_count)
	UIManager.change_player_obj_text(new_text)
	
	if e1m1_craimh_death == e1m1_craimg_count:
		e1m1_all_craimh_dead = !e1m1_all_craimh_dead
		UIManager.change_player_obj_text("return to the transport tube")
		print("bool e1m1_all_cnaimh_dead state: ", e1m1_all_craimh_dead)
	
