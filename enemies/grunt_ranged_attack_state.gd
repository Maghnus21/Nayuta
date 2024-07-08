extends State
class_name GunnerAttackState

@export var wait_time:float = 0.6667
@export var bullet_time:float = 0.30
var time_passed:float = 0.0
var bullet_time_passed:float = 0.0
var target


# Called when the node enters the scene tree for the first time.
func _ready():
	
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func enter_state():
	
	state_machine.entity.aware = true
	
	bullet_time = wait_time / 2.0
	time_passed = 0.0
	
	target = get_tree().get_first_node_in_group("player")
	
	state_machine.entity_anim_state_machine["parameters/conditions/fire"] = true
	#state_machine.entity_anim_state_machine["parameters/conditions/fire"] = false
	pass

func exit_state():
	pass

func update_state(delta):
	check_health()
	pass

func physics_update_state(delta):
	check_player_status()
	
	lerp_angle_rotate_towards_point(state_machine, state_machine.entity, target, 0.05)
	
	#
	if bullet_time_passed < bullet_time:
		bullet_time_passed +=delta
	else:
		bullet_time = 0.6667
		bullet_time_passed = 0
		state_machine.entity.fire_projectile(target)
	
	
	
	
	if time_passed < wait_time:
		time_passed +=delta
	else:
		time_passed = 0
		
		var distance = state_machine.entity.global_position.distance_to(target.global_position)
		
		if distance > 8.0:
			state_machine.change_state("chasestate")
	
	
	
	
	
	pass

func fire_projectile():
	pass

func check_player_status():
	if GlobalData.player_has_died:
		state_machine.change_state("idlestate")
	pass

