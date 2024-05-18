extends Node

@onready var player

var timer:float = 0.0
# Called when the node enters the scene tree for the first time.
func _ready():
	player = get_tree().get_first_node_in_group("player")
	print("found player: ", player)
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func _physics_process(delta):
	
	#if timer < 10.0:
		#
		#player_ui.reduce_health_bar_precentage(5)
		#timer = 0
	#else:
		#timer += delta
	pass
