extends Node3D

#	constants
var RAY_LENGTH = 3.0

#	exports and onready
@export var camera: Camera3D
@export var pickup_point: Node3D
@export var ray: RayCast3D
@export var player: CharacterBody3D
@export var player_col: CollisionShape3D


#	local
var held_obj

# Called when the node enters the scene tree for the first time.
func _ready():
	
	
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if Input.is_action_just_pressed("interact_key"):
		cast_ray()
		
	pass


func _physics_process(delta):
	pass

func cast_ray():
	var space = get_world_3d().direct_space_state
	var query = PhysicsRayQueryParameters3D.create(camera.global_position, camera.global_position - camera.global_transform.basis.z * 5)
	query.hit_from_inside = false
		
	var collision = space.intersect_ray(query)
	
	if collision:
		print("hit obj: ", collision.collider.name)
		if collision.collider.is_in_group("holdable"):
			print("holdable obj")




