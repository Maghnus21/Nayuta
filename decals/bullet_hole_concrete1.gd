extends Decal

@onready var timer:Timer = $Timer

# Called when the node enters the scene tree for the first time.
func _ready():
	set_as_top_level(true)
	
	timer.connect("timeout", Callable(self, "_on_timer_timeout"))
	timer.start()
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func _on_timer_timeout():
	queue_free()
