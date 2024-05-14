extends Node
class_name Dialogue

@export var entity_name:String = "Entity"
@export var dialogue_array:Array

var current_dialogue_index:int = 0


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func parse_dialogue_text() -> String:
	var current_dialogue_string:String
	current_dialogue_string = entity_name + ": " + dialogue_array[current_dialogue_index]
	
	current_dialogue_index += 1
	
	if current_dialogue_index > dialogue_array.size() - 1:
		current_dialogue_index = dialogue_array.size() - 1
	
	
	return current_dialogue_string 
	
	
