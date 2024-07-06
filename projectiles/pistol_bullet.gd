extends Node3D
class_name PistolBullet

@export var bullet_damage: float = 20.0
@export var raycast:RayCast3D
@export var bullet_speed: float
@export var bullet_grav: float = 0.0
@export var delete_time:= 3.0
var timer=0.0

var bullet_hole:PackedScene = preload("res://decals/bullet_hole_concrete1.tscn")
var concrete_impact_smoke:PackedScene = preload("res://particles/smoke_low.tscn")


var p1:Vector3
var p2:Vector3

var velocity: Vector3

# Called when the node enters the scene tree for the first time.
func _ready():
	set_as_top_level(true)
	
	velocity = self.transform.basis.z * bullet_speed
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	#print("updating raycast")
	
	
	
	pass


func _physics_process(delta):
	if timer < delete_time:
		timer += delta
	else:
		print("deleted bullet")
		queue_free()
	
	
	var distance = velocity.length() * delta
	
	self.transform.origin += Vector3(velocity.x, velocity.y - bullet_grav, velocity.z) * delta
	raycast.force_raycast_update()
	
	if raycast.is_colliding():
		#print("colliding")
		var collider = raycast.get_collider()
		
		if collider.is_in_group("level_mesh"):
			print("hit level mesh: ", collider.name)
			
			#intanciate_impact(raycast)
			
			queue_free()

		if collider.is_in_group("enemy"):
			collider.damage_entity(bullet_damage)
			print("hit enemy: ", collider.name, "\t health: ", collider.health)
			queue_free()
	
	
	

func set_projectile_rotation(rot):
	rotation = rot
	pass

func set_damage_value(new_damage_value:float):
	bullet_damage = new_damage_value
	pass

func set_speed(new_speed_value:float):
	bullet_speed = new_speed_value

# FIX decal look_at shitting itself
func instanciate_impact(ray):

	
	var impact_decal = bullet_hole.instantiate()
	var impact_smoke = concrete_impact_smoke.instantiate()
			
	#get_tree().get_root().add_child(impact_decal)
	ray.get_collider().add_child(impact_decal)
	get_tree().get_root().add_child(impact_smoke)
			
	impact_decal.global_transform.origin = ray.get_collision_point()
	impact_smoke.global_transform.origin = ray.get_collision_point()
	
	#impact_decal.look_at(ray.get_collision_point() - normal, Vector3.UP)
	
	if ray.get_collision_normal().dot(Vector3.UP) > 0.0000000000000000000001:
		var direction = ray.get_collision_point() + ray.get_collision_normal()
		if impact_decal.global_transform.origin != direction:
			impact_decal.look_at(direction, Vector3.UP)
	
	
	#impact_decal.look_at(ray.get_collision_point() + ray.get_collision_normal(), Vector3.UP)
	impact_smoke.emitting = true
	
