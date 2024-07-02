extends GPUParticles3D

@onready var timer:Timer = $Timer

@export var smoke_time:float = 5
@export var timer_one_shot:bool = true
@export var smoke_one_shot:bool = true

# Called when the node enters the scene tree for the first time.
func _ready():
	smoke_config()
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func smoke_config():
	timer.one_shot = timer_one_shot
	timer.wait_time = smoke_time
	
	timer.connect("timeout", Callable(self, "_on_timer_timeout"))
	timer.start()
	pass

func _on_timer_timeout():
	queue_free()
