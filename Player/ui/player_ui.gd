extends Control

@export_group("Player Status")
@export var health_bar:ColorRect
@export var energy_bar:ColorRect
@export_group("Player Weapons")
@export var weapon_name:RichTextLabel
@export var ammo_count_value:RichTextLabel
@export_group("Player Objective")
@export var objective_text:RichTextLabel

var delta_time:float = 0

var max_health_pixel_x_length:float = 270		#	default value 270
var max_energy_pixel_x_length:float = 270		#	default value 270


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func _physics_process(delta):
	delta_time = delta

func reduce_health_bar_precentage(amount: float):
	var precent_reduce = amount / 100		# pleayer health is at 100, add change for increasing health
	
	var pixel_reduction = max_energy_pixel_x_length * precent_reduce
	
	health_bar.size.x -= pixel_reduction
	pass

##	set weapon name using string
func set_weapon_name(name: String):
	#	[center] used to center richtextlabel text, requires BBCode enabled
	var new_text: String = "[center]" + name + "[/center]"
	weapon_name.set_text(new_text)
	pass

##	set ammunition count using current weapon ammo count (integer) and reserve ammo count (integer)
func set_ammo_count_value(weapon_ammo: int, reserve_ammo: int):
	#	[center] used to center richtextlabel text, requires BBCode enabled
	var new_text: String = "[center]" + var_to_str(weapon_ammo) + "/" + var_to_str(reserve_ammo) + "[/center]"
	ammo_count_value.set_text(new_text)
	pass

##	set objective text using string
func set_player_objective_text(new_objective_text: String):
	#	[center] used to center richtextlabel text, requires BBCode enabled
	var new_text: String = "[center]" + new_objective_text + "[/center]"
	objective_text.set_text(new_text)
	pass
