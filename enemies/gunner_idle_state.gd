extends State
class_name GunnerIdleState

@export var idle_rotate:bool = false
@export var sfx:AudioStreamPlayer3D

@export var raycast:RayCast3D

@export var target:Node3D

##	variables used for rotating entity on spot during idle state, eg similar to cruelty squad npc idle
@export var MAX_DETECT_ANGLE: float = 45.0		## default value: 30.0
@export var DETECT_RANGE: float = 8.0		## default value: 8.0
@export var MAX_ROT_ANGLE:float = 60.0

var rot_angle:float = 0.0
var rotate_time:float = 3.0
var reset_rot_time:float = 0.0

var open_face_time:float = 0.2667
var open_face_timer:float = 0.0
var played_scream:bool = false

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func enter_state():
	target = get_tree().get_first_node_in_group("player")
	
	print("Entity ", state_machine.entity , " entered state: ", self.name)
	
	pass


func exit_state():
	pass


func update_state(delta):
	check_health()
	pass


func physics_update_state(delta):
	#	called every physics update
	#var ray_data = cast_ray(state_machine.entity, DETECT_RANGE)
	var a = Vector2(state_machine.entity.global_position.x, state_machine.entity.global_position.z)
	var b = Vector2(target.global_position.x, target.global_position.z)
	
	var angle_to_ent:float = rad_to_deg(a.angle_to_point(b))
	#print (a, "\t ", b, "\t ", angle_to_ent)
	
	if angle_to_ent <= MAX_DETECT_ANGLE && angle_to_ent >= -MAX_DETECT_ANGLE && state_machine.entity.loc_check():
		
		if played_scream != true:
			sfx.play()
			played_scream = true
		
		print ("in detect range")
		
		open_face()
		
		if open_face_timer < open_face_time:
			open_face_timer +=delta
		else:
			open_face_timer = 0
			state_machine.entity.aware = true
			state_machine.change_state("chasestate")
			
		#state_machine.entity_anim_state_machine["parameters/IdleBlendTree/Add2/add_amount"] = 1
		
	 
	
	
	#if angle_to_ent > DETECT_ANGLE || angle_to_ent < -DETECT_ANGLE:
		#print("entity in detection range")
		#pass
	#
	
	
	
	
	pass


func new_rot_angle():
	pass


func open_face():
	state_machine.entity_anim_state_machine["parameters/IdleBlendTree/Add2/add_amount"] = 1.0
	pass

