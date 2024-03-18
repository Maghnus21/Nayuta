extends Control

@onready var window = $Window

@export var sfx_player:AudioStreamPlayer3D

var button_sound1:AudioStreamWAV
var button_sound2:AudioStreamWAV


# Called when the node enters the scene tree for the first time.
func _ready():
	button_sound1 = preload("res://sound/buttons/button14.wav")
	button_sound2 = preload("res://sound/buttons/button15.wav")
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

## allows nodes to change visibility of window 
func toggle_settings_window_visibility():
	play_audio(button_sound2)
	window.set_visible(!window.is_visible())
	return 

func play_audio(sound):
	sfx_player.stream = sound
	sfx_player.play()
	pass

func _on_window_close_requested():
	toggle_settings_window_visibility()
	pass # Replace with function body.
