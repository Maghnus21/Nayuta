extends Window

var window = self

@onready var audio_master_slider = $SettingsWindow/TabContainer/Audio/VBoxContainer/MasterAudio/Label/HSlider
@onready var sfx_music_slider = $SettingsWindow/TabContainer/Audio/VBoxContainer/SFXAudio/Label/HSlider
@onready var audio_music_slider = $SettingsWindow/TabContainer/Audio/VBoxContainer/MusicAudio/Label/HSlider

@onready var audio_master_label = $SettingsWindow/TabContainer/Audio/VBoxContainer/MasterAudio/Label/Label
@onready var audio_sfx_label = $SettingsWindow/TabContainer/Audio/VBoxContainer/SFXAudio/Label/Label
@onready var audio_music_label = $SettingsWindow/TabContainer/Audio/VBoxContainer/MusicAudio/Label/Label

#	scroll container for options
@export var video_scroll_container:ScrollContainer

var master_volume:float = 100.0		# default value - 100
var sfx_volume:float = 100.0		# default value - 100
var music_volume:float = 100.0		# default value - 100

enum window_mode { FULLSCREEN, BOARDERLESS, WINDOWED }



@onready var sfx_player:AudioStreamPlayer = $SFXStreamPlayer
@onready var music_player:AudioStreamPlayer = $MusicStreamPlayer
var music_toggle:bool = false

var button_sound1:AudioStreamWAV
var button_sound2:AudioStreamWAV

var current_tab:int = 0		# 0  is default tab


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
	#play_audio(button_sound2)
	window.set_visible(!window.is_visible())
	return 

func play_audio(sound):
	sfx_player.stream = sound
	sfx_player.play()
	pass

func _on_window_close_requested():
	toggle_settings_window_visibility()
	pass # Replace with function body.




func set_master_volume(vol: float):
	if vol < 0.0 || vol > 100.0:
		push_error("Tried exceeding limit on master volume. Attempted master volume value: ", vol)
		return
	master_volume = vol

func set_sfx_volume(vol:float):
	if vol < 0.0 || vol > 100.0:
		push_error("Tried exceeding limit on sfx volume. Attempted sfx volume value: ", vol)
		return
	sfx_volume = vol

func set_music_volume(vol:float):
	if vol < 0.0 || vol > 100.0:
		push_error("Tried exceeding limit on music volume. Attempted music volume value: ", vol)
		return
	music_volume = vol

func get_master_volume():
	return master_volume

func get_sfx_volume():
	return sfx_volume

func get_music_volume():
	return music_volume






func _on_master_vol_slider_value_changed(value):
	play_audio(button_sound2)
	
	if value < 0.0 || value > 1.0:
		push_error("Master audio value exceeding limit. Attempted value: ", value)
		return
	
	GlobalSettings.set_master_vol(value)
	audio_master_label.text = var_to_str(value*100)
	pass # Replace with function body.


func _on_music_vol_slider_value_changed(value):
	play_audio(button_sound2)
	
	if value < 0.0 || value > 1.0:
		push_error("Music audio value exceeding limit. Attempted value: ", value)
	
	GlobalSettings.set_music_vol(value)
	audio_music_label.text = var_to_str(value*100)
	pass # Replace with function body.


func _on_sfx_vol_slider_value_changed(value):
	play_audio(button_sound2)
	
	if value < 0.0 || value > 1.0:
		push_error("SFX audio value exceeding limit. Attempted value: ", value)
		
	GlobalSettings.set_sfx_vol(value)
	audio_sfx_label.text = var_to_str(value*100)
	pass # Replace with function body.


func _on_button_pressed():
	music_toggle = !music_toggle
	if music_toggle:
		music_player.play()
	else:
		music_player.stop()
	pass # Replace with function body.




func _on_resolution_option_button_item_selected(index):
	play_audio(button_sound2)
	
	GlobalSettings.set_game_resolution(index)
	pass # Replace with function body.


func _on_resolution_option_button_pressed():
	play_audio(button_sound2)
	pass # Replace with function body.


func _on_window_mode_option_button_pressed():
	play_audio(button_sound2)
	pass # Replace with function body.


func _on_window_mode_option_button_item_selected(index):
	play_audio(button_sound2)
	
	match index:
		0:
			DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_FULLSCREEN)
			DisplayServer.window_set_flag(DisplayServer.WINDOW_FLAG_BORDERLESS, true)
		1:
			DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_WINDOWED)
			DisplayServer.window_set_flag(DisplayServer.WINDOW_FLAG_BORDERLESS, true)
		2:
			DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_MINIMIZED)
			DisplayServer.window_set_flag(DisplayServer.WINDOW_FLAG_BORDERLESS, false)
	pass # Replace with function body.




func _on_aspect_ratio_option_button_pressed():
	play_audio(button_sound2)
	pass # Replace with function body.


func _on_close_requested():
	play_audio(button_sound1)
	self.hide()
	pass # Replace with function body.


func _on_tab_container_tab_clicked(tab):
	if tab != current_tab:
		current_tab = tab
		play_audio(button_sound1)
	pass # Replace with function body.


func _on_aspect_ratio_option_button_item_selected(index):
	play_audio(button_sound2)
	pass # Replace with function body.


func _on_size_changed():
	#	sets size of scroll container for video options to vector2 data from window size
	video_scroll_container._set_size(self.get_size())
	pass # Replace with function body.
