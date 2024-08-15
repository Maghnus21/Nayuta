extends Node3D
class_name MapData

# Called when the node enters the scene tree for the first time.
func _ready():
	# start autoloads here upon starting game
	GlobalData.start_global_data()
	UIManager.start_ui_manager()
	
	GlobalData.e1m1_update_craimh_death_count(0)
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
