extends Node3D


@onready var camera = $Camera3D
@export var rebound_area:Area3D
@export var player_arms:Node3D
#@onready var flashlight = $camera/Flashlight
@onready var player_controller:CharacterBody3D = get_parent()

@export var mouse_sensitivity:float = 1

var mouse_move:Vector2 = Vector2.ZERO
var mouse_rotation_x:float = 0.0
var y_offset:float = 0.75


# Called when the node enters the scene tree for the first time.
func _ready():
	Input.mouse_mode = Input.MOUSE_MODE_CAPTURED
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	self.rotation_degrees = Vector3(mouse_rotation_x, 0, 0)
	#camera.rotation_degrees = Vector3(mouse_rotation_x, 0, 0)
	rebound_area.rotation_degrees = Vector3(mouse_rotation_x, 0, 0)
	player_arms.rotation_degrees = Vector3(mouse_rotation_x, 0, 0)
	#flashlight.rotation_degrees = Vector3(mouse_rotation_x, 0, 0)
	pass

func _input(event):
	if event is InputEventMouseMotion:
		mouse_move = event.relative * 1.0
		
		mouse_rotation_x -= event.relative.y * mouse_sensitivity
		mouse_rotation_x = clamp(mouse_rotation_x, -90, 90)
		player_controller.rotate_y(deg_to_rad(-event.relative.x * mouse_sensitivity))


func _physics_process(delta):
	transform.origin = Vector3(0, y_offset, 0)
	pass
