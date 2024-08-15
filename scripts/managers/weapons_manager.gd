extends Node

# temp solution to weapon inventory
enum weapon_types {PISTOL, SMG, SHOTGUN}
var weapon_dict = {0:"res://player/viewmodel/usp.tscn", 1:"res://player/viewmodel/bt_mp9.tscn", 2:"res://player/viewmodel/spas.tscn"}

# max amout of rounds the player can hold for each round type
var BUCKSHOT_MAX_CARRY = 150
var _10MM_MAX_CARRY = 300
var _12_7MM_MAX_CARRY = 240


# max amount of rounds each weapons clip/magazine can store
var PISTOL_MAX_CLIP = 21
var SMG_MAX_CLIP = 45
var SHOTGUN_MAX_CLIP = 12


# amount of rounds weapon drops will give player
var PISTOL_DEFAULT_GIVE = 21
var SMG_DEFAULT_GIVE = 23
var SHOTGUN_DEFAULT_GIVE = 6

# weapon prop wigidbody weights
var PISTOL_PROP_WEIGHT:= 1.5
var SMG_PROP_WEIGHT:= 2.25
var SHOTGUN_PROP_WEIGHT:= 4.0

var player:Node3D
var player_weapon_node:Node3D

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func start_weapon_manager():
	set_player()
	set_player_weapon_node()

func set_player():
	player = get_tree().get_first_node_in_group("player")
	print(self,": found player ", player, ", populatiing player field")

func set_player_weapon_node():
	player_weapon_node = player.get_node("Head/WeaponParent")

func get_weapon_path(weapon:int) -> String:
	return weapon_dict[weapon]
	
	pass
