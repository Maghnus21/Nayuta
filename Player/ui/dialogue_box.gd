extends Control
class_name DialogueBox

var dialogue_store: Array
var dialogue_store_string: String

var kill_box_after_string:bool = false

@onready var dialogue_richtextlabel: RichTextLabel = $'DialogueRichTextLabel'
@onready var name_richtextlabel:RichTextLabel =  $'NameRichTextLabel'
@onready var audio_player: AudioStreamPlayer = $'AudioStreamPlayer'
@onready var type_timer: Timer = $'TypeTimer'
@onready var next_string_timer: Timer = $'NextStringTimer'
@onready var kill_timer: Timer = $'QueueFreeTimer'

var playing_voice:bool = false

var rng = RandomNumberGenerator.new()

# Called when the node enters the scene tree for the first time.
func _ready():
	rng.randomize()
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if Input.is_action_just_pressed("esc_key"):
		kill()
	pass

func update_dialogue_text(dialogue_text: String) -> void:
	dialogue_richtextlabel.set_text(dialogue_text)
	dialogue_richtextlabel.visible_characters = 0
	type_timer.start()
	
	playing_voice = true
	audio_player.play(0)
	pass

func update_name_text(name_string:String):
	name_richtextlabel.set_text(name_string)
	pass

func kill():
	GlobalData.is_player_in_dialogue = false
	GlobalData.entity_in_dialogue_sequence = null
	queue_free()

func _on_timer_timeout():
	if dialogue_richtextlabel.visible_characters < dialogue_richtextlabel.text.length():
		audio_player.play(0)
		audio_player_pitch_varience()
		dialogue_richtextlabel.visible_characters += 1
	else:
		playing_voice = false
		type_timer.stop()
		if kill_box_after_string:
			kill_timer.start(0)
	pass # Replace with function body.


func _on_audio_stream_player_finished() -> void:
	if playing_voice:
		audio_player.play(0)
	pass # Replace with function body.

func audio_player_pitch_varience():
	audio_player.pitch_scale = rng.randf_range(0.95, 1.0)
	pass


func _on_queue_free_timer_timeout():
	kill()
	pass # Replace with function body.
