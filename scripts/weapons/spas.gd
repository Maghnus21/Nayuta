extends Weapons
class_name SpasShotgun


@export var projectile:PackedScene
@export var bullet_spawn:Node3D
@export var bullet_spread:Vector3		#TODO: add gradual increase of weapon spread when firing weapon
@export var rpm:int = 1420
@export var buckshot_count:int = 12

@onready var cycle_time:float = 60.0/rpm
@onready var rof_timer:Timer = $Timers/RateOfFireTimer
@onready var reload_time:float = 0.6827 * 2		# timer is duration of holster animation. use this until reload animation is added
@onready var reload_timer:Timer = $Timers/ReloadTimer
var rounds_shot:int = 0

#var anim_tree

@onready var gunshot_source:AudioStreamPlayer = $AudioSources/GunShotAudioStreamPlayer
@onready var sfx_source:AudioStreamPlayer = $AudioSources/SFXAudioStreamPlayer

var trace_bullet_max_distance:float = 5.0	# if entity is within this distance of the player, it will instead damage the entity with raycast and not projectile

var gunshot_sound:AudioStreamWAV = preload("res://sound/weapons/shotgun_fire7.wav")
var reload_sound:AudioStreamWAV = preload("res://sound/weapons/uzi-submachine-gun_reload.wav")

var can_fire_weapon:bool = true		#default state true

var delta_time:float = 0.0		# globally accessible delta time variable

var rng

## TESTING PURPOSES ONLY, REMOVE LATER
## THIS IS TO BE REVISED FOR GREATER REUSABILITY
@export_category("TESTING")
@onready var muzzle_light:Light3D = $Muzzle/OmniLight3D
@export var muzzle_light_intensity:float = 0.1
@export var light_lerp_weight:float = 0.1

@onready var muzzle:Node3D = $Muzzle
@onready var smoke_scene:PackedScene = preload("res://particles/smoke_low.tscn")

var emit_smoke:bool = true

# Called when the node enters the scene tree for the first time.
func _ready():
	var player_node:Node3D = GlobalData.get_player()
	print(player_node)
	
	rof_timer.set_wait_time(cycle_time)
	
	#anim_tree = $AnimationTree.get("parameters/playback")
	
	#anim_tree.travel("smg_idle")
	
	rng = RandomNumberGenerator.new()
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	#if Input.is_action_pressed("mouse_left"):
		#primary_attack()
	#
	#if Input.is_action_just_pressed("r_key"):
		#reload()
	pass

func _physics_process(delta):
	if muzzle_light.light_energy > 0.0:
		muzzle_light.light_energy = lerpf(muzzle_light.light_energy, 0.0, light_lerp_weight)
	
	delta_time = delta
	pass

func primary_attack():
	if can_fire_weapon:
		
		for k in buckshot_count:
			fire_bullet()
		
		reset_muzzle_light()
		smoke()
		
		# smoke particle quanity check
		# emits smoke after ever 2nd shot
		#if emit_smoke:
			#smoke()
			#emit_smoke = !emit_smoke
		#else:
			#emit_smoke = !emit_smoke
		
		#anim_tree.start("smg_fire")
		
		play_shoot()
		rounds_shot = 0
		rof_timer.start()
		can_fire_weapon = false
	
	if rof_timer.is_stopped() && reload_timer.is_stopped():
		can_fire_weapon = true
	
	pass

# zoom in for smg until new ability can be taught of for it
func secondary_attack():
	pass

func fire_bullet():
	# calcualte new random spread for projectile
	rng.seed = hash(Time.get_ticks_usec() + rounds_shot)
	
	var x_mod = rng.randf_range(-bullet_spread.x, bullet_spread.x)
	var y_mod = rng.randf_range(-bullet_spread.y, bullet_spread.y)
	var z_mod = rng.randf_range(-bullet_spread.z, bullet_spread.z)
	
	#TODO: Add distance check for how close entity is close to player. if with spcified distance to player,
	# damage entity using raycast/trace and instantiate bullet with no damage value. if outside mex distance,
	# instantiate bullet projectile as normal
	
	#var distance:float
	#var collision = cast_ray(trace_bullet_max_distance)
	#
	#if collision:
		#var ray_start:Vector3 = GlobalData.player.get_node("Head/Camera3D").global_position
		#var ray_end:Vector3 = collision.position
		#
		#distance = ray_start.distance_to(ray_end)
		#
		#if distance <= trace_bullet_max_distance:
			#var trace_bullet:PistolBullet = PistolBullet.new()
			#
			#if collision.is_in_group("enemy"):
				#collision.damage_entity(trace_bullet.bullet_damage)
				#print("hit enemy: ", collision.name, "\t health: ", collision.health)
		#else:
			#
		#
		#pass
	
	var instance = projectile.instantiate()
	instance.bullet_damage = 15.0
	instance.position = bullet_spawn.position
	instance.rotation = bullet_spawn.rotation + Vector3(x_mod, y_mod, 0)
	
	get_parent().add_child(instance)
	
	pass

#func check_distance() -> bool:
	#pass

func can_fire() -> bool:
	#	check if can fire weapon at pointing at entity
	
	return can_fire_weapon 

func play_shoot():
	gunshot_source.stream = gunshot_sound
	gunshot_source.play()
	pass

func play_reload():
	sfx_source.stream = reload_sound
	sfx_source.play()
	pass

func reload():
	reload_timer.start(reload_time)
	can_fire_weapon = false
	play_reload()
	#anim_tree.travel("smg_holster")
	pass

func reset_muzzle_light():
	muzzle_light.light_energy = muzzle_light_intensity

## instantiates a smoke scene and emitts particles
func smoke():
	var smoke_node = smoke_scene.instantiate()
	muzzle.add_child(smoke_node)
	#var smoke_particles = smoke_node.get_node("SmokeLow")
	smoke_node.emitting = true

##	casts ray from center of screen to specified units forward
func cast_ray(range:float):
	var space = get_world_3d().direct_space_state
	var query = PhysicsRayQueryParameters3D.create(GlobalData.player.get_node("Head/Camera3D").global_position - GlobalData.player.get_node("Head/Camera3D").global_transform.basis.z * 0.6, GlobalData.player.get_node("Head/Camera3D").global_position - GlobalData.player.get_node("Head/Camera3D").global_transform.basis.z * range)
	query.hit_from_inside = false
	query.hit_back_faces = false
	
	var collision = space.intersect_ray(query)
	
	if collision == null:
		return null
	else:
		return collision

func _on_reload_timer_timeout():
	print("Weapon ", name, " can fire")
	can_fire_weapon = true
	pass # Replace with function body.
