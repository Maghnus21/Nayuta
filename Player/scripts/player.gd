extends Node3D

#	constants
var RAY_LENGTH = 3.0
var PULL_FORCE = 20.0
var THROW_FORCE = 8.0

#	exports and onready
@export var camera: Camera3D
@export var pickup_point: Node3D
@export var ray: RayCast3D
@export var player: CharacterBody3D
@export var player_col: CollisionShape3D


#	local
var held_obj:Node3D

# Called when the node enters the scene tree for the first time.
func _ready():
	
	
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if Input.is_action_just_pressed("interact_key"):
		if held_obj != null:
			drop_obj()
		else:
			cast_ray()
	
	if Input.is_action_just_pressed("mouse_left") && held_obj != null:
		throw_obj()
	
	pass


func _physics_process(delta):
	if held_obj != null:
		pickup()
	pass

func cast_ray():
	var space = get_world_3d().direct_space_state
	var query = PhysicsRayQueryParameters3D.create(camera.global_position, camera.global_position - camera.global_transform.basis.z * 5)
	query.hit_from_inside = false
		
	var collision = space.intersect_ray(query)
	
	if collision:
		print("hit obj: ", collision.collider.name)
		if collision.collider.is_in_group("holdable"):
			held_obj = collision.collider
			held_obj.global_rotation = pickup_point.global_rotation
			#held_obj.lock_rotation = true

func pickup():
	#held_obj.global_position = lerp(held_obj.global_position, pickup_point.global_position, 0.5)
	held_obj.set_linear_velocity((pickup_point.global_transform.origin - held_obj.global_transform.origin) * PULL_FORCE)
	pass

func drop_obj():
	held_obj.lock_rotation = false
	held_obj = null

func throw_obj():
	var forward = -camera.global_transform.basis.z
	
	held_obj.apply_impulse(forward * THROW_FORCE)
	drop_obj()
	
	pass
