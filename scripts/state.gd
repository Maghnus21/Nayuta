extends Node3D
class_name State

@export var state_machine:StateMachine

var entity_aware:bool = false

func enter_state() -> void:
	pass

func exit_state() -> void:
	pass

func update_state(_delta:float) -> void:
	pass

func physics_update_state(_delta:float) -> void:
	pass

##	rotates the entity on the y axis towards target position using lerp_angle
func lerp_angle_rotate_towards_point(state_machine, main_entity, target, rotate_weight):
	var target_pos = Vector2(target.position.x, target.position.z)
	var entity_pos = Vector2(main_entity.transform.origin.x, main_entity.transform.origin.z)
	
	var angle = entity_pos.angle_to_point(target_pos)
	#print(rad_to_deg(angle))
	
	#	90 degree offset applied as models are/should be rotated to face z+
	state_machine.entity.global_rotation.y = lerp_angle(state_machine.entity.rotation.y, -angle, rotate_weight)
	pass

func cast_ray(obj_trans, ray_length):
	var space = get_world_3d().direct_space_state
	var query = PhysicsRayQueryParameters3D.create(obj_trans.global_position, obj_trans.global_position - obj_trans.global_transform.basis.z * ray_length)
	query.hit_from_inside = false
		
	var collision = space.intersect_ray(query)
	
	## returns object dictionary
	return collision
	
	#if collision:
		#print("hit obj: ", collision.collider.name)
		#if collision.collider.is_in_group("holdable"):
			#held_obj = collision.collider
			#held_obj.global_rotation = pickup_point.global_rotation
			##held_obj.lock_rotation = true







