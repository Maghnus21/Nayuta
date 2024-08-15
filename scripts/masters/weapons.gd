extends Node3D
class_name Weapons

@export_enum("Pistol","SMG1", "Shotgun") var WeaponName:String
@export_enum("weapon", "pickup") var ItemType:String

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

##	casts trace from point node3d forwards for range amount. returns collision dicitionary if colliding with object, else returns null value
func cast_trace(point:Node3D, range:float):
	var space = get_world_3d().direct_space_state
	var query = PhysicsRayQueryParameters3D.create(point.global_position - point.global_transform.basis.z * 0.6, point.global_position - point.global_transform.basis.z * range)
	
	#	prevents trace from hitting player collider (its fucking retarded but works for now)
	query.hit_from_inside = false
	query.hit_back_faces = false
	
	var collision = space.intersect_ray(query)
	
	if collision == null:
		return null
	else:
		return collision

func destroy_item():
	#if attached to player
		#remove_from_player function
	#else
		#kill()
	pass

func add_to_player():
	pass

func drop_weapon():
	pass

func holster_weapon():
	pass

func eject_brass():
	pass

func gunshot_decal():
	pass

func spawn_blood():
	pass

##	deletes weapons
func kill():
	queue_free()
	pass

func reload():
	print("weapon reloaded")
