extends Node3D

@export var enemies:int = 27

@export var enemy_count_label:Label
# Called when the node enters the scene tree for the first time.
func _ready():
	Input.mouse_mode = Input.MOUSE_MODE_CAPTURED
	enemy_count_label.text = "Enemy count: " + var_to_str(enemies)
	
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	
	pass


func enemies_remaining(value):
	enemies -= value
	
	enemy_count_label.text = "Enemy count: " + var_to_str(enemies)
	
	if enemies == 0:
		get_tree().change_scene_to_file("res://menu/win_menu.tscn")
	
	pass
