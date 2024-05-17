extends Control

@export var health_bar:ColorRect
@export var energy_bar:ColorRect

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
