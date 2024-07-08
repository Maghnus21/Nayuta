extends Area3D

var has_triggered_dialogue:bool = false

@onready var dialogue:Dialogue = $NPCDialogue

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func _on_body_entered(body):
	if body.is_in_group("player") && !has_triggered_dialogue:
		GlobalData.entity_in_dialogue_sequence = self
		body.start_dialogue_sequence(dialogue.parse_dialogue_text())
		has_triggered_dialogue = !has_triggered_dialogue
		pass
	pass # Replace with function body.
