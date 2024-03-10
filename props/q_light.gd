extends OmniLight3D


@export_enum("NORMAL:m",
"FLICKER:mmnmmommommnonmmonqnmmo",
"SLOW_PULSE:abcdefghijklmnopqrstuvwxyzyxwvutsrqponmlkjihgfedcba",
"CANDLE:mmmmmaaaaammmmmaaaaaabcdefgabcdefg",
"FAST_STROBE:mamamamamama",
"GENTLE_PULSE1:jklmnopqrstuvwxyzyxwvutsrqponmlkj",
"FLICKER2:nmonqnmomnmomomno",
"CANDLE2:mmmaaaabcdefgmmmmaaaammmaamm",
"CANDLE3:mmmaaammmaaammmabcdefaaaammmmabcdefmmmaaaa",
"SLOW_STROBE:aaaaaaaazzzzzzzz",
"FLOURSCENT_FLICKER:mmamammmmammamamaaamammma",
"SLOW_PULSE_NOT_FADE_TO_BLACK:abcdefghijklmnopqrrqponmlkjihgfedcba"
) var LIGHT_MODE

@export var read_speed:int = 10

var default_brightness
var count = 0

# Called when the node enters the scene tree for the first time.
func _ready():
	default_brightness = light_energy
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	#if count != read_speed
	
	count+=1
	
	pass
