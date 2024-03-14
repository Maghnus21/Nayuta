extends Node

class_name StateMachine

@export var initial_state: State

@export var entity: CharacterBody3D
@export var entity_corpse: PackedScene
@export var entity_anim_state_machine:AnimationTree

@export var nav_agent: NavigationAgent3D
@export var entity_range:=15.0

@export var debug_entity:=false

var current_state: State
var states : Dictionary = {}

enum body_parts {eyes, ears, nose}


# Called when the node enters the scene tree for the first time.
func _ready():
	for child in get_children():
		if child is State:
			states[child.name.to_lower()] = child
			#child.Transition.connect(on_child_transition)
	
	if debug_entity: print(states)
	
	if initial_state:
		initial_state.enter_state()
		current_state = initial_state
	
	

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if current_state:
		current_state.update_state(delta)
	pass

func _physics_process(delta):
	if current_state:
		current_state.physics_update_state(delta)

func on_child_transition(state, new_state_name):
	if state != current_state:
		return
	
	var new_state = states.get(new_state_name.to_lower())
	
	if !new_state:
		return
	
	if current_state:
		current_state.exit_state()
	
	new_state.enter_state()
	
	current_state = new_state
	
	

func change_state(state_name):
	var nu_state = states.get(state_name.to_lower())
	
	if !nu_state:
		return
	if current_state:
		current_state.exit_state()
	
	nu_state.enter_state()
	
	current_state = nu_state
	print("current state: ", current_state)
	
	#current_state.enter_state()
	
	pass
