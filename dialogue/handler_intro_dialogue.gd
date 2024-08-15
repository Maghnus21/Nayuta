extends Dialogue

#var last_string:bool = false

# Called when the node enters the scene tree for the first time.
func _ready():
	dialogue_array = [
		"good, you’ve landed at the target area. preliminary scans of the nearby building shows there’s 26 cnaimh. the head honchos requested for an extermination order, in collaberation with MHI.",
		"we’ve been able to supply you with some weapons to assist you and thanks to MHI’s transport lines, we’ve got you to a safehouse. quite lucky that the target area is next door, so you don’t have to travel far.",
		"scans have shown the cnaimh are low level, stage 1s, so you shouldn’t have too much trouble, but they can still do damage so stay alert.",
		"you know youself, once the task has been completed, come back to the transport pod to exfil.",
		"good luck, and happy hunting."
		]
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func parse_dialogue_text() -> String:
	var current_dialogue_string:String
	current_dialogue_string = dialogue_array[current_dialogue_index]
	
	current_dialogue_index += 1
	
	if current_dialogue_index > dialogue_array.size() - 1:
		current_dialogue_index = dialogue_array.size() - 1
		last_string = !last_string
	
	
	return current_dialogue_string 
	#return dialogue_line
