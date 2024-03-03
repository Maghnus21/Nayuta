##	modified version of pmove_full from repo https://github.com/Btan2/Q_Move (uses godot 3 functions)
##	TODO: implement ladder climbing (half life 2), ground slide (dishonored), swimming


extends CharacterBody3D

@export var ray_foot:RayCast3D
var current_mesh:MeshInstance3D
@export var audio_player:AudioStreamPlayer3D

const MOUSE_SENSATIVITY = 1200

@onready var player_collider:CollisionShape3D = $CollisionShape3D
@onready var sfx_audio_player:AudioStreamPlayer3D = $"AudioSources/sfx"
@onready var player_audio: AudioStreamPlayer3D = $"AudioSources/player_feet"
@onready var head:Node3D = $Head
@onready var player_mesh:MeshInstance3D = $MeshInstance3D

## NOTE: when changing collider height via crouch, ground check collider must also be changed
## TODO: change code so groundcheck only moves to (player y - shape height/2) and crouchcheck should behave same way
@onready var ground_check_shapecast:ShapeCast3D = $GroundCheckShapeCast3D
@onready var crouch_check_shapecast:ShapeCast3D = $CrouchCheckShapeCast3D

@onready var debug_label:Label = $Control/Label

const MOVESPEED:float = 12.0
const WALKSPEED:float = 6.0
const STOPSPEED:float = 10.0
const GRAVITY:float = 64.0
const ACCELERATE:float = 10.0
const AIRACCELERATE:float = 9.81
const MOVEFRICTION:float = 6.0
const JUMPFORCE:float = 20.0
const AIRCONTROL:float = 0.9
const STEPSIZE:float = 1.8
const MAXHANG:float = 0.2
const PLAYER_HEIGHT:float = 2.0
const CROUCH_HEIGHT:float = 1.0
const PLAYER_MASS:float = 80.0

@export var min_fall_damage_dis:int = 20

var deltaTime:=0.0
var move_speed: float = 32.0
var fmove:float = 0.0
var smove:float = 0.0
var ground_normal:Vector3 = Vector3.UP
var hang_time:float = 0.2
var impact_velocity:float = 0.0
var is_dead:bool = false
var crouch_press:bool = false
var jump_press:bool = false
var ground_plane:bool = false
var noclip:bool = false
var prev_y:float = 0.0
var vel:Vector3 = Vector3.UP
var crouched_under_low_obj:bool = false

enum STATELIST {WALK, FALL, SLIDE, SWIM, LADDER, NOCLIP}
var current_state: STATELIST = STATELIST.WALK

var land_audio

var debug_dict = {
	"current_speed": 0,
	"current_loc": Vector3(0,0,0)
}


#	audio to be used for footsteps will have path strings stored here and stream field in player uses strings to fetch files
#	audio then should be played according to material type; concrete, sand, metal, etc
#	TODO: check if system could be used for enemies
var footstep_sound_dict = {"default": ["null", "null"],
"concrete": ["res://assets/audio/concrete_step_4.wav"],
"metal": ["null"]}


func _ready():
	
	#	preload audio here
	land_audio = preload("res://sound/player/footsteps/concrete3.wav")
	pass

func _input(event):
	
	#	if player dead, will ignore user inputs
	if is_dead:
		fmove = 0.0
		smove = 0.0
		jump_press = false
		return
	
	fmove = Input.get_action_strength("movement_forward") - Input.get_action_strength("movement_backward")
	smove = Input.get_action_strength("movement_right") - Input.get_action_strength("movement_left")
	
	move_speed = MOVESPEED
	
	if Input.is_action_just_pressed("movement_jump") and !jump_press:
		jump_press = true
	elif Input.is_action_just_released("movement_jump"):
		jump_press = false
	
	## TODO: fix bug where if player jumps in small area only accessible by crouching, eg vent, crouch_press will change to false causing the player
	## to switch from crouching to standing frequently. can be solved easily by player by crouching again but unknown if player will fall through map
	if Input.is_action_pressed("movement_crouch"):
		crouch_press = true
		if move_speed == MOVESPEED:
			move_speed = WALKSPEED
		else:
			move_speed = WALKSPEED/2.0
	else:
		if crouch_check_shapecast.is_colliding() && ground_check_shapecast.is_colliding():
			crouch_press = true
		else:
			crouch_press = false
	
	
	pass

func _physics_process(delta):
	deltaTime = delta
	
	crouch()
	catagorize_pos()
	jump_button()
	check_state()
	update_debug_info()
	
	#print(player_collider.global_transform.origin)

func check_state():
	match(current_state):
		STATELIST.WALK:
			ground_move()
		STATELIST.FALL:
			air_move()
			#pass

#	crouch method
##	TODO: make so player won't uncrouch when grounded, crouching, and crouch_check isn't colliding
func crouch():
	var crouch_speed = 20.0 * deltaTime
	
	if crouch_press:
		#	changes the crouch_check shape to match height of player collider pre crouch
		crouch_check_shapecast.shape.height = (PLAYER_HEIGHT - CROUCH_HEIGHT)
		
		if current_state == STATELIST.FALL:
			player_collider.shape.height = CROUCH_HEIGHT
			#ground_check_shapecast.shape.height = CROUCH_HEIGHT + 0.2
			ground_check_shapecast.target_position.y = -(CROUCH_HEIGHT/2) - (ground_check_shapecast.shape.height/2)
			crouch_check_shapecast.target_position.y = (CROUCH_HEIGHT/2) + (crouch_check_shapecast.shape.height/2)
		else:
			player_collider.shape.height = CROUCH_HEIGHT
			ground_check_shapecast.target_position.y = -(CROUCH_HEIGHT/2) - (ground_check_shapecast.shape.height/2)
			crouch_check_shapecast.target_position.y = (CROUCH_HEIGHT/2) + (crouch_check_shapecast.shape.height/2)
			#ground_check_shapecast.shape.height -= (PLAYER_HEIGHT + 0.2)
	else:
		#	returns shape target position to original position
		ground_check_shapecast.target_position.y = -(PLAYER_HEIGHT/2) - (ground_check_shapecast.shape.height/2)
		crouch_check_shapecast.target_position.y = (PLAYER_HEIGHT/2) - (crouch_check_shapecast.shape.height/2)	# prevents collider from reacing above player collider
		crouch_check_shapecast.shape.height = 0.1	#resets height
		
		if player_collider.shape.height < PLAYER_HEIGHT:
			var up = transform.origin + (Vector3.UP * crouch_speed)
			#var trace = Trace.new()
			#trace.motion(transform.origin, up, player_collider.shape, self)
			if ground_check_shapecast.is_colliding():
				player_collider.shape.height += crouch_speed
				#ground_check_shapecast.shape.height+= crouch_speed
	
	player_collider.shape.height = clamp(player_collider.shape.height, CROUCH_HEIGHT, PLAYER_HEIGHT)
	head.y_offset = player_collider.shape.height * 0.35
	
	pass

#	check if player is touching ground
func catagorize_pos():
	#var down:Vector3
	#var trace:Trace
	#
	#trace = Trace.new()
	#
	## Check for ground 0.1 units below the player
	#down = global_transform.origin + (Vector3.DOWN * 0.1)
	#trace.full(global_transform.origin, down, player_collider.shape, self)
	
	ground_plane = false
	
	
	if !ground_check_shapecast.is_colliding():
		current_state = STATELIST.FALL
		ground_normal = Vector3.UP
	else:
		ground_plane = true
		#ground_normal = trace.normal
		
		if ground_normal[1] < 0.7:
			current_state = STATELIST.FALL
		
		else:
			if current_state == STATELIST.FALL:
				calc_fall_damage()
			
			#global_transform.origin = trace.endpos
			prev_y = global_transform.origin[1]
			impact_velocity = 0
		
			current_state = STATELIST.WALK
	
	pass

#	calculates fall damage to be applied to player 
func calc_fall_damage():
	var fall_dis: int
	
	fall_dis = int(round(abs(prev_y - global_transform.origin[1])))
	if fall_dis >= min_fall_damage_dis && impact_velocity >= 45:
		jump_press = false
		print("applied fall damage")
	else:
		if fall_dis < min_fall_damage_dis:
			#sfx_audio_player.stream = land_audio
			sfx_audio_player.play()
			print("landed safely")

func jump_button():
	if is_dead:
		return
	
	if current_state != STATELIST.FALL:
		hang_time = MAXHANG
	else:
		hang_time -= deltaTime if hang_time > 0.0 else 0.0
	
	#	don't jump if moving up too fast
	if velocity[1] > 60.0:
		return
	
	if hang_time > 0.0 && jump_press:
		current_state = STATELIST.FALL
		jump_press = false
		hang_time = 0.0
		
		#var jump_sound = preload("res://assets/audio/jump_01.ogg")
		#player_audio.stream = jump_sound
		#player_audio.play()
		
		# makes sure jump velocity is positive if moving down
		if current_state == STATELIST.FALL || velocity[1] < 0.0:
			velocity[1] = JUMPFORCE
		else:
			velocity[1] += JUMPFORCE

func ground_move():
	var wishdir:Vector3
	
	wishdir = ((global_transform.basis.x * smove) + (-global_transform.basis.z * fmove)).normalized()
	wishdir = wishdir.slide(ground_normal)
	
	ground_accelerate(wishdir, slope_speed(ground_normal[1]))
	#var original_velocity = velocity
	
	var ccd_max = 5
	for _i in range(ccd_max):
		var ccd_step = velocity / ccd_max
		var collision = move_and_collide(ccd_step * deltaTime)
		if collision:
			var normal = collision.get_normal()
			if normal[1] < 0.7 and !is_dead:
				#var stepped = step_move(global_transform.origin, velocity.normalized() * 10)
				var stepped = false
				if !stepped and velocity.dot(normal) < 0:
					velocity = velocity.slide(normal)
			else:
				velocity = velocity.slide(normal)

## unused but keep for posterity
func step_move(original_pos : Vector3, vel : Vector3):
	var dest:Vector3
	var down:Vector3
	var up:Vector3
	var trace:Trace
	
	trace = Trace.new()
	
	# Get destination position that is one step-size above the intended move
	dest = original_pos
	dest[0] += vel[0] * deltaTime
	dest[1] += STEPSIZE
	dest[2] += vel[2] * deltaTime
	
	# 1st Trace: check for collisions one stepsize above the original position
	up = original_pos + Vector3.UP * STEPSIZE
	trace.standard(original_pos, up, player_collider.shape, self)
	
	dest[1] = trace.endpos[1]
	
	# 2nd Trace: Check for collisions one stepsize above the original position
	# and along the intended destination
	trace.standard(trace.endpos, dest, player_collider.shape, self)
	
	# 3rd Trace: Check for collisions below the stepsize until 
	# level with original position
	down = Vector3(trace.endpos[0], original_pos[1], trace.endpos[2])
	trace.standard(trace.endpos, down, player_collider.shape, self)
	
	# Move to trace collision position if step is higher than original position 
	# and not steep 
	if trace.endpos[1] > original_pos[1] and trace.normal[1] >= 0.7: 
		global_transform.origin = trace.endpos
		#velocity = velocity.slide(trace.normal)
		return true
	
	return false

func ground_accelerate(wishdir : Vector3, wishspeed : float):
	var friction : float
	var speed    : float 
	
	friction = MOVEFRICTION
	speed = velocity.length()
	
	if  current_state == STATELIST.LADDER:
		friction = 30.0
	elif speed > 0.0:
		# If the leading edge is over a dropoff, increase friction
		var start = global_transform.origin
		start[0] += velocity[0] / speed * 1.6
		start[2] += velocity[2] / speed * 1.6
		var stop = Vector3.ZERO
		stop[0] = start[0]
		stop[1] = start[1] - 3.6
		stop[2] = start[2]
		#var trace = Trace.new()
		#trace.motion(start, stop, player_collider.shape, self)
		#if trace.fraction == 1:
			#friction *= 2.0
	
	# Friction applied after move release
	if wishdir != Vector3.ZERO:
		velocity = velocity.lerp(wishdir * wishspeed, ACCELERATE * deltaTime) 
	else:
		velocity = velocity.lerp(Vector3.ZERO, friction * deltaTime) 

func air_move():
	var wishdir:Vector3
	
	wishdir = ((global_transform.basis.x * smove) + (-global_transform.basis.z * fmove)).normalized()
	wishdir = wishdir.slide(ground_normal)
	
	air_accelerate(wishdir, STOPSPEED if velocity.dot(wishdir) < 0 else AIRACCELERATE)
	
	if !ground_plane:
		if (AIRCONTROL > 0.0):
			air_control(wishdir)
	
	velocity[1] -= GRAVITY * deltaTime
	
	if global_transform.origin[1] >= prev_y:
		prev_y = global_transform.origin[1]
	
	impact_velocity = abs(int(round(velocity[1])))
	
	var ccd_max = 5
	for _i in range(ccd_max):
		var ccd_step = velocity / ccd_max
		var collision = move_and_collide(ccd_step * deltaTime)
		if collision:
			var normal = collision.get_normal()
			if velocity.dot(normal) < 0:
				velocity = velocity.slide(normal)
	
	
	pass

func air_accelerate(wishdir:Vector3, accel:float):
	var add_speed:float
	var accel_speed:float
	var current_speed:float
	
	var wishspeed = slope_speed(ground_normal[1])
	
	current_speed = velocity.dot(wishdir)
	add_speed = wishspeed - current_speed
	if add_speed <= 0.0:
		return
	
	accel_speed = accel * deltaTime * wishspeed
	if accel_speed > add_speed: accel_speed = add_speed
	
	velocity[0] += accel_speed * wishdir[0]
	velocity[1] += accel_speed * wishdir[1]
	velocity[2] += accel_speed * wishdir[2]

func air_control(wishdir:Vector3):
	var dot:float
	var speed:float
	var original_y:float
	
	if fmove == 0.0:
		return
	
	original_y = velocity[1]
	velocity[1] = 0.0
	speed = velocity.length()
	velocity = velocity.normalized()
	
	dot = velocity.dot(wishdir)
	if dot > 0.0:
		var k = 32.0 * AIRCONTROL * dot * dot * deltaTime
		velocity[0] = velocity[0] * speed + wishdir[0] * k
		velocity[1] = velocity[1] * speed + wishdir[1] * k
		velocity[2] = velocity[2] * speed + wishdir[2] * k
		velocity = velocity.normalized()
	
	velocity[0] *= speed
	velocity[1] = original_y
	velocity[2] *= speed

func slope_speed(y_normal:float):
	if y_normal <= 0.97:
		var multiplier = y_normal if velocity[1] > 0.0 else 2.0 - y_normal
		return clamp(move_speed * multiplier, 5.0, move_speed * 1.2)
	return move_speed

func push(force:float, dir:Vector3, mass:float):
	for i in range(3):
		velocity[i] += force * dir[i]/mass

func update_debug_info():
	
	var player_velocity_info:String
	var player_pos_info:String
	var player_ground_check_info:String
	var g_c_pos_info:String
	var crouch_state:String
	
	
	player_velocity_info  = "player velocity: " + var_to_str(velocity.length())
	
	player_pos_info = "player position: " + var_to_str(transform.origin)
	
	var grounded:bool
	if current_state != STATELIST.WALK:	grounded = false
	else: grounded = true
	
	player_ground_check_info = "player grounded: " + var_to_str(grounded)
	
	g_c_pos_info = "ground check target pos: " + var_to_str(ground_check_shapecast.target_position)
	
	crouch_state = "player crouching: " + var_to_str(crouch_press)
	
	
	var player_info_string:String = player_velocity_info + "\n" + player_pos_info + "\n" + player_ground_check_info + "\n" + g_c_pos_info + "\n" + crouch_state
	
	debug_label.text = player_info_string
	
	pass
























