extends Node
class_name State

func enter_state():
	pass

func exit_state():
	pass

func update_state(_delta:float):
	pass

func physics_update_state(_delta:float):
	pass

##	rotates the entity on the y axis towards target using lerp_angle
func lerp_angle_rotate_towards_point(main_entity, target, rotate_speed):
	pass
