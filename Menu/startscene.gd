extends Control

var target_scene = "res://maps/e1/e1m1.tscn"

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func _on_button_pressed():
	print("shit")
	get_tree().change_scene_to_file("res://maps/e1/e1m1.tscn")
	pass # Replace with function body.
