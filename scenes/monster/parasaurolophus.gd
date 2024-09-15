extends CharacterBody3D

@onready var navigation_agent_3d: NavigationAgent3D = $NavigationAgent3D
@onready var model: Node3D = $ParasaurolophusModel
@onready var animation_tree: AnimationTree = $ParasaurolophusModel/AnimationTree

const SPEED: float = 5.0
const ACCELLERATION: float = 0.1
const FRICTION: float = 0.5

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
	
func _physics_process(delta: float) -> void:
	var destination = navigation_agent_3d.get_next_path_position()
	var local_destination = destination - global_position
	var move_direction = local_destination.normalized()
	
	if move_direction:
		velocity.x = move_toward(velocity.x, move_direction.x * SPEED, ACCELLERATION)
		velocity.z = move_toward(velocity.z, move_direction.z * SPEED, ACCELLERATION)
	else:
		velocity.x = move_toward(velocity.x, 0, FRICTION)
		velocity.z = move_toward(velocity.z, 0, FRICTION)
	
	animation_tree.set("parameters/idle_walk_blend/blend_amount", min(Vector2(velocity.x, velocity.z).length() / SPEED, 1.0))
	move_and_slide()
	
	if velocity.length() > 0.2:
		var look_direction = Vector2(velocity.z, velocity.x)
		model.rotation.y = lerp_angle(model.rotation.y, look_direction.angle(), ACCELLERATION)

func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed("ui_accept"):
		var random_position := Vector3.ZERO
		random_position.x = randf_range(-20.0, 20.0)
		random_position.z = randf_range(-20.0, 20.0)
		navigation_agent_3d.target_position = random_position
