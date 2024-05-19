extends Node3D
class_name EnemyProjectile

@export var bullet_damage: float = 20.0
@export var raycast:RayCast3D
@export var bullet_speed: float
@export var bullet_grav: float = 0.0
@export var delete_time:= 3.0
var timer=0.0

var bullet_hole:PackedScene


var np:Vector3		# new position
var lp:Vector3		# last position

var velocity: Vector3

# Called when the node enters the scene tree for the first time.
func _ready():
	set_as_top_level(true)
	
	#bullet_hole = preload("res://decals/bullet_hole_concrete_decal.tscn")
	
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
			
			queue_free()

		if collider.is_in_group("player"):
			collider.damage(bullet_damage)
			print("hit player")
			queue_free()


func _set_rotation(rot):
	self.rotation = rot
	pass

func delete_projectile():
	queue_free()

