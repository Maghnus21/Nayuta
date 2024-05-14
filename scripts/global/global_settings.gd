extends Node

var music_bus_index:int = 1
var sfx_bus_index:int = 2

#	in-development resolutions
var resolution_dict: Dictionary = {
	0: Vector2i(640, 480), 
	1: Vector2i(1280, 720), 
	2: Vector2i(1600, 900), 
	3: Vector2i(1920, 1080),
	4: Vector2i(2560, 1440),
	5: Vector2i(1200, 1200)
	}

#	resolutions to be added later
var resolutions_3_2: Dictionary = {
	0: Vector2i(720, 480), 	#3:2
	1: Vector2i(1152, 768),
	2: Vector2i(1280, 854),
	3: Vector2i(1440, 960),
	4: Vector2i(2880, 1920)
}

var resolutions_4_3: Dictionary = {
	0: Vector2i(320, 240),
	1: Vector2i(640, 480),
	2: Vector2i(800, 600),
	3: Vector2i(1024, 768),
	4: Vector2i(1152, 864),
	5: Vector2i(1280, 960),
	6: Vector2i(1400, 1050),
	7: Vector2i(1600, 1200),
	8: Vector2i(2048, 1536)
}

var resolution_5_3: Dictionary = {
	0: Vector2i(800, 480),
	1: Vector2i(1280, 768)
}

var resolution_5_4: Dictionary = {
	0: Vector2i(1280, 1024),
	1: Vector2i(2560, 2048)
}

var resolution_16_9: Dictionary = {
	0: Vector2i(852, 480),
	1: Vector2i(1280, 720),
	2: Vector2i(1366, 768),
	3: Vector2i(1600, 900),
	4: Vector2i(1920, 1080),
	5: Vector2i(2560, 2440),
	6: Vector2i(3840, 2160)
}

var resolution_16_10: Dictionary = {
	0: Vector2i(320, 200),
	1: Vector2i(640, 400),
	2: Vector2i(1280, 800),
	3: Vector2i(1440, 900),
	4: Vector2i(1680, 1050),
	5: Vector2i(1920, 1200),
	6: Vector2i(2560, 1600)
}




# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func toggle_window_mode(value):
	pass

func set_master_vol(value):
	#	master audio bus index is always 0
	AudioServer.set_bus_volume_db(0, linear_to_db(value))

func set_music_vol(value):
	AudioServer.set_bus_volume_db(music_bus_index, linear_to_db(value))

func set_sfx_vol(value):
	AudioServer.set_bus_volume_db(sfx_bus_index, linear_to_db(value))
	pass

func set_game_resolution(index):
	match index:
		0:
			DisplayServer.window_set_size(resolution_dict[0])
			pass
		1:
			DisplayServer.window_set_size(resolution_dict[1])
			pass
		2:
			DisplayServer.window_set_size(resolution_dict[2])
			pass
		3:
			DisplayServer.window_set_size(resolution_dict[3])
			pass
		5:
			DisplayServer.window_set_size(resolution_dict[5])
	
