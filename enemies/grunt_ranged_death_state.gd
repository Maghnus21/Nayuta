extends State
class_name GunnerStateName

@export var col:CollisionShape3D

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
func enter_state():
	state_machine.entity_anim_state_machine["parameters/conditions/death"] = true
	col.disabled = true
	
	state_machine.entity.game_manager.enemies_remaining(1)
	pass

func exit_state():
	pass

func update_state(delta):
	pass

func physics_update_state(delta):
	pass
