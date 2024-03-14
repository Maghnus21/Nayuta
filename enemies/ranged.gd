extends CharacterBody3D

@export var los_raycast:RayCast3D
@export var projectile_spawn:Node3D
@export var projectile:PackedScene

var aware:bool = false

var health:float = 80.0

# Called when the node enters the scene tree for the first time.
func _ready():
	preload("res://projectiles/bullet.tscn")
	
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func fire_projectile(target):
	
	
	#	applies offset to prevent shooting at feet
	var player_transform = Vector3(target.global_position.x, target.global_position.y + 1, target.global_position.z)
	
	projectile_spawn.look_at(target.global_position, Vector3.UP, true)
	
	var instance = projectile.instantiate()
	instance.rotation = projectile_spawn.rotation
	add_child(instance)
	instance.global_position = projectile_spawn.global_position
	
	#print("spawn: ", projectile_spawn.global_rotation)
	#print("bullet: ", instance.global_rotation)
	
	#var player_target
	#
	#los_raycast.force_raycast_update()
	#
	#if los_raycast.is_colliding():
		#var target = los_raycast.get_collider()
		#
		#if target.is_in_group("player"):
			#player_target = target
			#
			##	applies offset to prevent shooting at feet
			#var player_transform = Vector3(player_target.global_position.x, player_target.global_position.y + 1, player_target.global_position.z)
			#
			#projectile_spawn.look_at(player_target.global_position, Vector3.UP, true)
			#
			#var instance = projectile.instantiate()
			#instance.rotation = projectile_spawn.rotation
			#add_child(instance)
			#instance.global_position = projectile_spawn.global_position
			#
			#print("spawn: ", projectile_spawn.global_rotation)
			#print("bullet: ", instance.global_rotation)
	pass


func damage_entity(damage):
	health -= damage
	print(health)
