extends RigidBody3D

## prerequisites: turn on contact monitor and change max contacts reported to 1. settings found in rigidbody -> solver


@export var audio_source: AudioStreamPlayer3D

var MAX_VELOCITY = 1.0

# Called when the node enters the scene tree for the first time.
func _ready():
	audio_source.play()
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func _on_body_entered(body):
	#if abs(self.linear_velocity.x) > MAX_VELOCITY || abs(self.linear_velocity.y) > MAX_VELOCITY || abs(self.linear_velocity.z) > MAX_VELOCITY :
		#audio_source.play()
	audio_source.play()
	
	pass # Replace with function body.


func _on_audio_stream_player_3d_finished():
	pass # Replace with function body.
