extends Node3D

@export var bullet_damage: float = 20.0
@export var raycast:RayCast3D
@export var bullet_speed: float
@export var bullet_grav: float = 0.0
@export var delete_time:= 3.0
var timer=0.0

var bullet_hole:PackedScene = preload("res://decals/bullet_hole_concrete1.tscn")
var concrete_impact_smoke:PackedScene = preload("res://particles/smoke_low.tscn")


var nrp:Vector3		# new ray position
var lrp:Vector3		# last ray position

var velocity: Vector3

# Called when the node enters the scene tree for the first time.
func _ready():
	set_as_top_level(true)
	
	#bullet_hole = preload("res://decals/bullet_hole_concrete_decal.tscn")
	
	velocity = self.transform.basis.z * bullet_speed
	
	print("pos1:", nrp, "\tpos2:", lrp)
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
			
			instanciate_impact(raycast.get_collision_point())
			
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

func instanciate_impact(pos):
	var impact_decal = bullet_hole.instantiate()
	var impact_smoke = concrete_impact_smoke.instantiate()
			
	get_tree().get_root().add_child(impact_decal)
	get_tree().get_root().add_child(impact_smoke)
			
	impact_decal.global_position = pos
	impact_smoke.global_position = pos
			
	impact_smoke.emitting = true
	
