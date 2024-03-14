extends Node3D

#	constants
var RAY_LENGTH:float = 3.0
var PULL_FORCE:float = 20.0
var THROW_FORCE:float = 8.0
var MAX_HEALTH:float = 20.0

#	exports and onready
@export var camera: Camera3D
@export var pickup_point: Node3D
@export var ray: RayCast3D
@export var player: CharacterBody3D
@export var player_col: CollisionShape3D
@export var projectile:PackedScene
@export var active_weapon:weapons
@export var raycast:RayCast3D

@export var pistol:Node3D
@export var smg:Node3D
@export var shotgun:Node3D

@export var pistol_barrel:Node3D
@export var smg_barrel:Node3D
@export var shotgun_barrel:Node3D

@export var pistol_bullet:PackedScene
@export var smg_bullet:PackedScene
@export var shotgun_bullet:PackedScene

@export var sfx_source:AudioStreamPlayer3D
@export var gun_source:AudioStreamPlayer3D


#	local
var health:float = 0.0

var held_obj:Node3D
var rng
@export var playermv:Node3D


var pistol_damage:float = 30.0
var smg_damage:float = 18.0
var shotgun_damage:float = 22.0

var pistol_rpm:int = 300
var smg_rpm:int = 1000
var shotgun_rpm:int = 60

var pistol_spread:float = 0.01
var smg_spread:float = 0.02
var shotgun_spread:float = 0.08

var pistol_audio:AudioStreamWAV
var smg_audio:AudioStreamWAV
var shotgun_audio:AudioStreamWAV

var rate_of_fire:float = 0.0
var time_passed:float = 0.0


enum weapons {UNARMED, PISTOL, SMG, SHOTGUN}



# Called when the node enters the scene tree for the first time.
func _ready():
	health = MAX_HEALTH
	
	pistol_audio = preload("res://sound/weapons/pistol_gunshot.wav")
	smg_audio = preload("res://sound/weapons/smg_fire1.wav")
	shotgun_audio = preload("res://sound/weapons/shotgun_fire1.wav")
	
	rng = RandomNumberGenerator.new()
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	
	
	player_attack(delta)
	change_weapon()
	
	if Input.is_action_just_pressed("interact_key"):
		if held_obj != null:
			drop_obj()
		else:
			cast_ray(5.0)
	
	if Input.is_action_just_pressed("mouse_left") && held_obj != null:
		throw_obj()



func _physics_process(delta):
	if held_obj != null:
		pickup()
	
	#check_health()
	pass

func cast_ray(range:float):
	var space = get_world_3d().direct_space_state
	var query = PhysicsRayQueryParameters3D.create(camera.global_position - camera.global_transform.basis.z * 0.6, camera.global_position - camera.global_transform.basis.z * range)
	query.hit_from_inside = false
		
	var collision = space.intersect_ray(query)
	
	#return collision
	
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

func fire_shotgun():
	raycast.force_raycast_update()
	var ray_endpoint = raycast.get_collision_point()
	
	var col = cast_ray(1000)
	
	shotgun_barrel.look_at(ray_endpoint,  Vector3.UP, true)
	
	gun_source.stream = shotgun_audio
	gun_source.play()
	
	shoot_bullets(shotgun_barrel, 10, Vector3(shotgun_spread,shotgun_spread,0))
	pass

func fire_pistol():
	raycast.force_raycast_update()
	var ray_endpoint = raycast.get_collision_point()
	
	var col = cast_ray(1000)
	
	pistol_barrel.look_at(ray_endpoint,  Vector3.UP, true)
	
	gun_source.stream = pistol_audio
	gun_source.play()
	
	shoot_bullets(pistol_barrel, 1, Vector3(pistol_spread,pistol_spread,0))
	pass

func fire_smg():
	raycast.force_raycast_update()
	var ray_endpoint = raycast.get_collision_point()
	
	var col = cast_ray(1000)
	
	smg_barrel.look_at(ray_endpoint,  Vector3.UP, true)
	
	gun_source.stream = smg_audio
	gun_source.play()
	
	shoot_bullets(smg_barrel, 1, Vector3(smg_spread,smg_spread,0))
	pass

func rebound():
	pass

func shoot_bullets(bullet_spawn:Node3D, bullet_count:int, spread:Vector3):
	rng.seed = hash(Time.get_ticks_usec())
	
	for n in bullet_count:
		var x_mod = rng.randf_range(-spread.x, spread.x)
		var y_mod = rng.randf_range(-spread.y, spread.y)
		
		var instance = projectile.instantiate()
		instance.position = bullet_spawn.global_position
		#print("bullet pos: ", instance.global_position, "\t spawn pos", bullet_spawn.global_position)
		instance.rotation = bullet_spawn.global_rotation + Vector3(x_mod, y_mod, 0)
		get_parent().get_parent().add_child(instance)
		
		#rng.seed(t.get_ticks_msec() + x_mod)
	
	
	pass

func player_attack(delta):
	
	if Input.is_action_pressed("mouse_left") && time_passed > rate_of_fire:
		if active_weapon == weapons.PISTOL:
			fire_pistol()
			pass
		elif active_weapon == weapons.SMG:
			fire_smg()
			pass
		elif  active_weapon == weapons.SHOTGUN:
			fire_shotgun()
			pass
		else:
			pass
		time_passed = 0
	else:
		time_passed += delta

func  change_weapon():
	if Input.is_action_just_pressed("alpha_1"):
		active_weapon = weapons.PISTOL
		rate_of_fire = 60.0 / pistol_rpm
		time_passed = 0.0
		
		pistol.visible = true
		smg.visible = false
		shotgun.visible = false
	if Input.is_action_just_pressed("alpha_2"):
		active_weapon = weapons.SMG
		rate_of_fire = 60.0 / smg_rpm
		time_passed = 0.0
		
		pistol.visible = false
		smg.visible = true
		shotgun.visible = false
	if Input.is_action_just_pressed("alpha_3"):
		active_weapon = weapons.SHOTGUN
		rate_of_fire = 60.0 / shotgun_rpm
		time_passed = 0.0
		
		pistol.visible = false
		smg.visible = false
		shotgun.visible = true

func damage(damage_amount):
	print(health)
	pass





