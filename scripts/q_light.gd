extends Node3D

## enum storing titles of lighting modes
@export_enum("NORMAL", "FLICKER", "SLOW_PULSE", "CANDLE", "FAST_STROBE", "GENTLE_PULSE1", "FLICKER2", "CANDLE2", "CANDLE3", "SLOW_STROBE", "FLOURSCENT_FLICKER", "SLOW_PULSE_NOT_FADE_TO_BLACK") var LIGHT_MODE:String

## titles and light strings added here
## light string values are read in lowercase, 
var light_options = {"NORMAL":"m",
"FLICKER":"mmnmmommommnonmmonqnmmo",
"SLOW_PULSE":"abcdefghijklmnopqrstuvwxyzyxwvutsrqponmlkjihgfedcba",
"CANDLE":"mmmmmaaaaammmmmaaaaaabcdefgabcdefg",
"FAST_STROBE":"mamamamamama",
"GENTLE_PULSE1":"jklmnopqrstuvwxyzyxwvutsrqponmlkj",
"FLICKER2":"nmonqnmomnmomomno",
"CANDLE2":"mmmaaaabcdefgmmmmaaaammmaamm",
"CANDLE3":"mmmaaammmaaammmabcdefaaaammmmabcdefmmmaaaa",
"SLOW_STROBE":"aaaaaaaazzzzzzzz",
"FLOURSCENT_FLICKER":"mmamammmmammamamaaamammma",
"SLOW_PULSE_NOT_FADE_TO_BLACK":"abcdefghijklmnopqrrqponmlkjihgfedcba"}

##	determins how quickly values will change depending on physics engine, eg 10 = 10fps until change. tied to physics engine. default value = 10
@export var read_speed:int = 10
##	"smooth_transistion" enabled lerps light values making lighting slowly fade. if disabled, lighing will behave like original quake lighting, suddenly changing light energ, making it flicker
@export var smooth_transistion:bool = false
## used in tandem with "smooth_transistion"
@export var transistion_weight:float = 0.5

var light_string:String
var default_brightness
var count = 0
var current_char
var current_lmc_loc = 0

#generic variable
@export var light:Light3D

# Called when the node enters the scene tree for the first time.
func _ready():
	default_brightness = light.light_energy

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if count == read_speed:
		update_light_value()
		update_light_level()
		count = 0
	
	count+=1
	pass

func update_light_value():
	light_string = light_options[LIGHT_MODE]
	
	if current_lmc_loc > light_string.length() - 1:
		current_lmc_loc = 0
	else:
		current_char = light_string[current_lmc_loc]
		current_lmc_loc += 1
	pass

func update_light_level():
	#	changes char to lower to prevent light energy being stuck as 0
	current_char.to_lower()
	var brightness_multi:float = (current_char.unicode_at(0)-96.0) / 13.0
	
	if !smooth_transistion:
		light.light_energy = default_brightness * brightness_multi
	
	else:
		light.light_energy = lerp(light.light_energy, default_brightness * brightness_multi, transistion_weight)
	
	pass
