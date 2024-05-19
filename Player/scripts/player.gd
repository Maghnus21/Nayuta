extends Node3D

#	constants
var RAY_LENGTH:float = 3.0
var PULL_FORCE:float = 20.0
var THROW_FORCE:float = 256.0
var MAX_HEALTH:float = 100.0
var FLASHLIGHT_MIN_DIS:float = 3.0
var MELEE_COOLDOWN:float = 0.4			# time must be equal to melee animation time
var REBOUND_COOLDOWN:float = 0.6
var REBOUND_MAX_TIME:float = 0.4		# time must be equal to rebound animation time
var REBOUND_BASE_DAMAGE:float = 120.2

var DIALOGUE_BOX_VISIBLE_TIME:float = 8.0


@export_category("Boolean variables")
@export var show_debug_info:bool = false		# displays debug info to label. default state: false
@export var adjusting_flashlight:bool = true	# moves flashlight behind player if too close to object. default state: true

@export_category("Exported Nodes")
@export var camera: Camera3D
@export var pickup_point: Node3D
@export var ray: RayCast3D
@export var player: CharacterBody3D
@export var player_col: CollisionShape3D
@export var projectile:PackedScene
@export var active_weapon:weapons
@export var raycast:RayCast3D
@export var rebound_area:Area3D
@export var rebound_col:CollisionShape3D
@export var rebound_spawn:Node3D
@export var label: Label

@export var dialogue_box:Control
@export var dialogue_text:RichTextLabel
@export var name_dialogue_text:RichTextLabel

@export var exit_timer: Timer

@export_category("Player Items")
@export var player_flashlight:Light3D

@export var pistol:Node3D
@export var smg:Node3D
@export var shotgun:Node3D

@export var pistol_barrel:Node3D
@export var smg_barrel:Node3D
@export var shotgun_barrel:Node3D

@export var pistol_bullet:PackedScene
@export var smg_bullet:PackedScene
@export var shotgun_bullet:PackedScene

@export_category("UI")
@export var player_ui:Control

@export_category("Audio Sources")
@export var sfx_source:AudioStreamPlayer3D
@export var gun_source:AudioStreamPlayer3D
@export var dialogue_audio:AudioStreamPlayer


#	local
var health:float = 0.0

var flashlight_state:bool = false
var melee_rebound_state:bool = false
var rebound_box_timer:float = 0.0
var rebound_timer:float = 0.0
var melee_timer:float = 0.0
var rebound_cooldown_timer:float = 0.0

var held_obj:Node3D
var rng
var delta_time


var pistol_damage:float = 30.0
var smg_damage:float = 18.0
var shotgun_damage:float = 22.0

var pistol_rpm:int = 300
var smg_rpm:int = 1000
var shotgun_rpm:int = 60

var pistol_spread:float = 0.01
var smg_spread:float = 0.02
var shotgun_spread:float = 0.08

var melee_miss:AudioStreamWAV
var melee_hit_default:AudioStreamWAV
var melee_hit_entity:AudioStreamWAV
var pistol_audio:AudioStreamWAV
var smg_audio:AudioStreamWAV
var shotgun_audio:AudioStreamWAV

var arm_state_machine
var ricochet:AudioStreamWAV
var ricochet_miss:AudioStreamWAV


var rate_of_fire:float = 0.0
var time_passed:float = 0.0

#	weapon enums and variables
enum weapons {UNARMED, PISTOL, SMG, SHOTGUN}
var last_used_weap

enum arm {MELEE, REBOUND}
var arm_state
var can_melee:bool = true
var can_rebound:bool = true
var num_of_projectiles_in_area:int = 0
var rebound_box_array:Array


var flashlight_sound:AudioStreamWAV

var dialogue_box_timer:float = 0.0
var is_in_dialogue:bool = false

# Called when the node enters the scene tree for the first time.
func _ready():
	health = MAX_HEALTH
	
	arm_state_machine = $'AnimationTree'.get("parameters/playback")
	
	#	preloading audioclips for weapons
	melee_miss = preload("res://sound/weapons/claw_miss1.wav")
	melee_hit_default = preload("res://sound/weapons/crowbar_impact1.wav")
	melee_hit_entity = preload("res://sound/physics/flesh/flesh_impact_bullet1.wav")
	pistol_audio = preload("res://sound/weapons/pistol_fire2.wav")
	smg_audio = preload("res://sound/weapons/smg1_fire1.wav")
	shotgun_audio = preload("res://sound/weapons/shotgun_fire7.wav")
	ricochet = preload("res://sound/weapons/ricochet1.wav")
	ricochet_miss = preload("res://sound/weapons/ricochet_miss.wav")
	
	flashlight_sound = preload("res://sound/items/flashlight1.wav")
	
	rng = RandomNumberGenerator.new()
	
	dialogue_box.visible = false
	
	#set_flashlight_state(false)
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	player_attack(delta)
	change_weapon()
	pick_up_obj()

func _physics_process(delta):
	delta_time = delta
	
	flashlight_distance()
	cooldown_timers()
	player_hud()
	
	if held_obj != null:
		hold_obj()
	
	#check_health()

func player_hud():
	if dialogue_box.visible:
		dialogue_box_timer += delta_time
		
		if dialogue_box_timer >= DIALOGUE_BOX_VISIBLE_TIME:
			dialogue_box.visible = false
			dialogue_box_timer = 0.0
	pass

##	casts ray from center of screen to specified units forward
func cast_ray(range:float):
	var space = get_world_3d().direct_space_state
	var query = PhysicsRayQueryParameters3D.create(camera.global_position - camera.global_transform.basis.z * 0.6, camera.global_position - camera.global_transform.basis.z * range)
	query.hit_from_inside = false
	query.hit_back_faces = false
	
	var collision = space.intersect_ray(query)
	
	if collision == null:
		return null
	else:
		return collision

##	checks if player has pressed interact key currently "F" and picks up rigidbody object
func pick_up_obj():
	if Input.is_action_just_pressed("interact_key"):
		talk(cast_ray(5.0))
		
		#if held_obj != null:
			#drop_obj()
		#else:
			#pickup(cast_ray(5.0))	# calls cast_ray to return PhysicsRayQueryParameter3D data and is set to pickuk func
	#
	if Input.is_action_just_pressed("mouse_left") && held_obj != null:
		throw_obj()
	
	pass

##	uses data from "cast_ray()" func and checks node group. if meets requirements, picks up object
func pickup(collision):
	if collision:
		print("hit obj: ", collision.collider.name)
		if collision.collider.is_in_group("holdable"):
			change_weapon_by_int(weapons.UNARMED)
			
			held_obj = collision.collider
			held_obj.global_rotation = pickup_point.global_rotation
	pass

func talk(collision):
	if collision:
		if collision.collider.is_in_group("talkable") && !is_in_dialogue:
			#print(collision.collider)
			update_dialogue_text(collision.collider.get_node("NPCDialogue").parse_dialogue_text())
	
	else:
		print("cannot talk")
	

##	moves object to holding point vector using physics. object will bump into walls
##	TODO increase pull force overtime to try and get object to point
func hold_obj():
	held_obj.set_linear_velocity((pickup_point.global_transform.origin - held_obj.global_transform.origin) * PULL_FORCE)
	pass

##	drops held object and changes weapon to last used weapon
func drop_obj():
	change_weapon_by_int(last_used_weap)
	
	held_obj.lock_rotation = false
	held_obj = null

##	applies force to object and then dropped
func throw_obj():
	change_weapon_by_int(last_used_weap)
	
	var forward = -camera.global_transform.basis.z
	
	held_obj.apply_impulse(forward * THROW_FORCE / held_obj.get_mass())
	drop_obj()

##	shotgun
func fire_shotgun():
	var col = cast_ray(1000)
	
	shotgun_barrel.look_at(col.position,  Vector3.UP, true)
	
	gun_source.stream = shotgun_audio
	gun_source.play()
	
	shoot_bullets(shotgun_barrel, 10, Vector3(shotgun_spread,shotgun_spread,0))

##	pistol
func fire_pistol():
	var col = cast_ray(1000)
	
	pistol_barrel.look_at(col.position,  Vector3.UP, true)
	
	gun_source.stream = pistol_audio
	gun_source.play()
	
	shoot_bullets(pistol_barrel, 1, Vector3(pistol_spread,pistol_spread,0))

##	sub machinegun
func fire_smg():
	var col = cast_ray(1000)
	
	smg_barrel.look_at(col.position,  Vector3.UP, true)
	
	gun_source.stream = smg_audio
	gun_source.play()
	
	shoot_bullets(smg_barrel, 1, Vector3(smg_spread,smg_spread,0))

func rebound():
	if rebound_col.disabled:
		rebound_col.disabled = false
	
	var projectile_array:int = rebound_area.get_overlapping_bodies().size()
	
	shoot_rebound_bullets(camera.global_position, 1, Vector3.ZERO, REBOUND_BASE_DAMAGE * (1 + (projectile_array/10.0)))
	
	rebound_col.disabled = true
	
	pass


##	function to shoot bullets from spawn point, number of bullets, and spread
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
	
	pass

##	function to see if player pressed input, fires weapon depending on enum
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
	
	if Input.is_action_just_pressed("mouse_right") && can_melee && can_rebound:
		check_melee_rebound()
		pass

func check_melee_rebound():
	#	enables collision for area3d collider child node
	melee_rebound_state = true
	
	var projectile_count:int = 0
	var area3d_array = rebound_area.get_overlapping_bodies()
	
	#	projectiles take priority over melee hit for consistancy and fairness
	var temp_n:int = 0
	for n in area3d_array:
		if area3d_array[temp_n].is_in_group("projectile"):
			projectile_count += 1
			temp_n += 1
		pass
	
	if projectile_count == 0:
		arm_state = arm.MELEE
	
	if projectile_count >= 1:
		arm_state = arm.REBOUND
	
	match (arm_state):
		arm.MELEE:
			print("MELEE HIT")
			
			arm_state_machine.travel("r_arm_punch")
			
			melee()
			start_melee_cooldown()
		arm.REBOUND:
			print("REBOUND PROJECTILE")
			play_sound_effect(ricochet)
			
			
			arm_state_machine.travel("r_arm_rebound")
			
			shoot_rebound_bullets(rebound_spawn.global_position, 1, Vector3(0,0,0),REBOUND_BASE_DAMAGE * (1 + (projectile_count/10)) )
			start_rebound_cooldown()
	
	
	pass

## increases cooldown timer variables to appropiate max time consts
func cooldown_timers():
	if melee_timer > 0.0:
		melee_timer -= delta_time
	elif melee_timer <= 0.0:
		can_melee = true
	
	if rebound_timer > 0.0:
		rebound_timer -= delta_time
	elif rebound_timer <= 0.0:
		can_rebound = true
	
	pass

func start_melee_cooldown():
	can_melee = false
	melee_timer = MELEE_COOLDOWN
	pass

func start_rebound_cooldown():
	can_rebound = false
	rebound_timer = REBOUND_COOLDOWN
	pass

##	change weapons using inputs
func  change_weapon():
	if Input.is_action_just_pressed("t_key"):
		use_flashlight()
		pass
	
	if Input.is_action_just_pressed("alpha_1"):
		last_used_weap = active_weapon
		
		active_weapon = weapons.PISTOL
		rate_of_fire = 60.0 / pistol_rpm
		time_passed = 0.0
		
		pistol.visible = true
		smg.visible = false
		shotgun.visible = false
	if Input.is_action_just_pressed("alpha_2"):
		last_used_weap = active_weapon
		
		active_weapon = weapons.SMG
		rate_of_fire = 60.0 / smg_rpm
		time_passed = 0.0
		
		pistol.visible = false
		smg.visible = true
		shotgun.visible = false
	if Input.is_action_just_pressed("alpha_3"):
		last_used_weap = active_weapon
		
		active_weapon = weapons.SHOTGUN
		rate_of_fire = 60.0 / shotgun_rpm
		time_passed = 0.0
		
		pistol.visible = false
		smg.visible = false
		shotgun.visible = true

func change_weapon_by_int(new_weapon):
	match new_weapon:
		#	UNARMED
		1: 
			last_used_weap = active_weapon
			print(last_used_weap)
			active_weapon = weapons.UNARMED
			
			pistol.visible = false
			smg.visible = false
			shotgun.visible = false
			
		
		#	pistol
		2:
			last_used_weap = active_weapon
			
			active_weapon = weapons.PISTOL
			rate_of_fire = 60.0 / pistol_rpm
			time_passed = 0.0
		
			pistol.visible = true
			smg.visible = false
			shotgun.visible = false
		
		#	smg
		3:
			last_used_weap = active_weapon
			
			active_weapon = weapons.SMG
			rate_of_fire = 60.0 / smg_rpm
			time_passed = 0.0
		
			pistol.visible = false
			smg.visible = true
			shotgun.visible = false
		
		#	shotgun
		4:
			last_used_weap = active_weapon
			
			active_weapon = weapons.SHOTGUN
			rate_of_fire = 60.0 / shotgun_rpm
			time_passed = 0.0
		
			pistol.visible = false
			smg.visible = false
			shotgun.visible = true
	pass

func damage(damage_amount):
	
	player_ui.reduce_health_bar_precentage(damage_amount)
	
	print(health)
	pass

func use_flashlight():
	flashlight_state = !flashlight_state
	set_flashlight_state(flashlight_state)
	pass

func set_flashlight_state(state:bool):
	play_sound_effect(flashlight_sound)
	player_flashlight.set_visible(state)
	pass

#	moves player's spotlight node back on z axis if player is too close to object (imitating half life 2 flashlight)
func flashlight_distance():
	if !flashlight_state:
		return
	
	var col = cast_ray(3)
	
	#	col is storing raycast dictionary, is_empty checks if it stores no values
	#	lerps flaslight to position behind player camera to maintain light size
	#	NOTE: feature enabled/disabled using adjusting_flashlight bool
	if !col.is_empty() && adjusting_flashlight:
		#print(col.position)
		var flashlight_pos = player_flashlight.global_transform.origin
		var distance = flashlight_pos.distance_to(col.position)
		player_flashlight.position.z = lerp(player_flashlight.position.z, (FLASHLIGHT_MIN_DIS-distance), 0.35)
	else:
		#	moves flashlight to original position if player quickly moves backwards from wall / entity
		player_flashlight.position.z = lerp(player_flashlight.position.z, 0.0, 0.35)
		pass
	
	pass

func play_sound_effect(audio_sound:AudioStream):
	sfx_source.set_stream(audio_sound)
	sfx_source.play()
	pass

func _on_rebound_area_3d_body_entered(body):
	#if body.is_in_group("projectile"):
		#print("objects in area3d")
	pass # Replace with function body.

func shoot_rebound_bullets(bullet_spawn:Vector3, bullet_count:int, spread:Vector3, damage_mod:float):
	rng.seed = hash(Time.get_ticks_usec())
	
	for n in bullet_count:
		var x_mod = rng.randf_range(-spread.x, spread.x)
		var y_mod = rng.randf_range(-spread.y, spread.y)
		
		var instance = projectile.instantiate()
		instance.set_damage_value(damage_mod)
		instance.set_speed(90.0)
		instance.position = bullet_spawn
		#print("bullet pos: ", instance.global_position, "\t spawn pos", bullet_spawn.global_position)
		instance.rotation = rebound_spawn.global_rotation + Vector3(x_mod, y_mod, 0)
		get_parent().get_parent().add_child(instance)
		
		print("instanciated rebound bullet")
	
	pass

func melee():
	var col = cast_ray(3.0)
	
	if col.is_empty():
		gun_source.set_stream(melee_miss)
		gun_source.play() 
		print("miss")
		return
	
	if !col.is_empty():
		gun_source.set_stream(melee_hit_default)
		gun_source.play()
		print(col.collider)
	
	if col.collider.is_in_group("enemy"):
		gun_source.set_stream(melee_hit_entity)
		col.collider.damage_entity(50.0)
		gun_source.play()
		print("hit enemy")

func update_dialogue_text(new_text):
	#dialogue_box.visible = true
	#dialogue_box_timer = 0.0
	#
	#dialogue_text.text = new_text
	#dialogue_audio.stream = preload("res://sound/sh2/SH2 Whisper.mp3")
	#dialogue_audio.play()
	
	is_in_dialogue = true
	
	var dialogue_box_packed_scene: PackedScene = preload("res://player/ui/dialogue_box.tscn")
	var dialogue_box_instance = dialogue_box_packed_scene.instantiate()
	player_ui.add_child(dialogue_box_instance)
	dialogue_box_instance.update_dialogue_text(new_text)
	
	exit_timer.start(0)
	
	pass



func _on_exit_dialogue_timeout():
	player_ui.get_node("DialogueBox").queue_free()
	is_in_dialogue = false
	pass # Replace with function body.
