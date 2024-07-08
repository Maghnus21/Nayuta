extends Node

"Player variables"
var player:Node3D
var player_ui_node:Control
var dialogue_box:PackedScene = preload("res://player/ui/dialogue_box.tscn")
var dialogue_box_instance


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func _physics_process(delta):
	
	pass

func start_ui_manager():
	set_player()
	pass

## sets player variable with node3d
func set_player():
	player = get_tree().get_first_node_in_group("player")
	print(self, ": found player ", player, ", populatiing player field")

## returns player as node3d
func get_player() -> Node3D:
	return player

func start_dialogue(new_text:String):
	dialogue_box_instance = dialogue_box.instantiate()
	player.get_node("PlayerHUD/PlayerUI").add_child(dialogue_box_instance)
	dialogue_box_instance.update_dialogue_text(new_text)
	dialogue_box_instance.update_name_text(GlobalData.entity_in_dialogue_sequence.get_node("NPCDialogue").entity_name)
	pass

func progress_dialogue(new_text:String):
	if GlobalData.entity_in_dialogue_sequence.get_node("NPCDialogue").last_string:
		dialogue_box_instance.kill_box_after_string = true
	dialogue_box_instance.update_dialogue_text(new_text)
	pass

func change_player_obj_text(new_text:String):
	player.get_node("PlayerHUD/PlayerUI").set_player_objective_text(new_text)
