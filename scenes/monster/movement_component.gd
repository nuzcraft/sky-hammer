extends Node
class_name MovementComponent

@onready var navigation_agent_3d: NavigationAgent3D = $"../NavigationAgent3D"

const SPEED: float = 5.0
const ACCELLERATION: float = 0.1
const FRICTION: float = 0.5

var velocity: Vector3

func move(pos: Vector3) -> Vector3:
	var destination = navigation_agent_3d.get_next_path_position()
	var local_destination = destination - pos
	var move_direction = local_destination.normalized()
	
	if move_direction:
		velocity.x = move_toward(velocity.x, move_direction.x * SPEED, ACCELLERATION)
		velocity.z = move_toward(velocity.z, move_direction.z * SPEED, ACCELLERATION)
	else:
		velocity.x = move_toward(velocity.x, 0, FRICTION)
		velocity.z = move_toward(velocity.z, 0, FRICTION)
	
	return velocity
