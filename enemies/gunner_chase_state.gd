extends State
class_name GunnerChaseState

@export var entity_accel = 4.0
@export var entity_speed = 16.0
@export var reset_destination_time:= 0.75

@export var attack_range:float = 8.0

var target

# Called when the node enters the scene tree for the first time.
func _ready():
	#if state_machine.nav_agent == null:
		#state_machine.nav_agent = get_node("NavigationAgent3D")
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func enter_state():
	print("entity ", state_machine.entity, " entered state: ", self.name)
	state_machine.entity_anim_state_machine["parameters/conditions/fire"] = false
	state_machine.entity_anim_state_machine["parameters/conditions/run"] = true
	
	if state_machine.entity.aware:
		open_face()
	
	target = get_tree().get_first_node_in_group("player")
	
	target_destination(target)
	pass

func exit_state():
	pass

func update_state(delta):
	pass

func physics_update_state(delta):
	# check if player is within shooting distance
	var distance = state_machine.entity.global_position.distance_to(target.global_position)
	
	if distance <= attack_range:
		state_machine.change_state("attackstate")
	
	
	var direction = Vector3()
	
	direction = state_machine.nav_agent.get_next_path_position() - state_machine.entity.global_position
	direction = direction.normalized()
	
	state_machine.entity.velocity = state_machine.entity.velocity.lerp(direction * entity_speed, entity_accel * delta)
	
	lerp_angle_rotate_towards_point(state_machine, state_machine.entity, target, 0.1)
	
	state_machine.entity.move_and_slide()
	
	if reset_destination_time > 0:
		reset_destination_time -= delta
	
	else:
		target_destination(target)
		reset_destination_time = 0.75
	pass

func target_destination(target):
	state_machine.nav_agent.target_position = target.global_position
	print("set target position: ",  target.global_position)


func open_face():
	state_machine.entity_anim_state_machine["parameters/RunBlendTree/Add2/add_amount"] = 1.0


