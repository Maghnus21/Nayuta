extends Control

@onready var settings_window = $'../SettingsWindow'

@onready var audio_player = $'../Camera3D/AudioStreamPlayer3D'

var button_press_audio1:AudioStreamWAV
var button_press_audio2:AudioStreamWAV

var settings_menu_visible:bool = false

var target_scene = "res://maps/e1/e1m1.tscn"

# Called when the node enters the scene tree for the first time.
func _ready():
	button_press_audio1 = preload("res://sound/buttons/button14.wav")
	button_press_audio2 = preload("res://sound/buttons/button15.wav")
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func _on_button_pressed():
	play_audio(button_press_audio1)
	
	print("shit")
	get_tree().change_scene_to_file("res://maps/e1/e1m1.tscn")
	pass # Replace with function body.

func _on_button_2_pressed():
	#play_audio(button_press_audio1)
	
	settings_window.toggle_settings_window_visibility()
	pass # Replace with function body.


func _on_settings_window_close_requested():
	play_audio(button_press_audio1)
	
	settings_menu_visible = false
	settings_window.visible = settings_menu_visible
	pass # Replace with function body.


func play_audio(sound):
	audio_player.stream = sound
	audio_player.play()
