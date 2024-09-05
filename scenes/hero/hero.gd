extends CharacterBody3D
class_name Hero

@export var RUN_SPEED: float = 5.0
@export var SPRINT_SPEED: float = 10.0
var speed: float = RUN_SPEED
const JUMP_VELOCITY: float = 4.5
const ACCELLERATION: float = 0.3
const FRICTION: float = 0.8

@onready var camera_joint: SpringArm3D = $CameraJoint
@onready var model: Node3D = $HeroModel
@onready var animation_tree: AnimationTree = model.get_node("AnimationTree")
@onready var animation_player: AnimationPlayer = model.get_node("AnimationPlayer")

var sheathed: bool = true

func _physics_process(delta: float) -> void:
	if not is_on_floor():
		velocity += get_gravity() * delta

	if Input.is_action_just_pressed("attack") and sheathed:
		animation_tree.set("parameters/unsheath_shot/request", AnimationNodeOneShot.ONE_SHOT_REQUEST_FIRE)
		animation_tree.set("parameters/sheath_state/transition_request", "unsheathed")
		sheathed = false

	var move_direction := Vector3.ZERO
	move_direction.x = Input.get_action_strength("right") - Input.get_action_strength("left")
	move_direction.z = Input.get_action_strength("down") - Input.get_action_strength("up")
	move_direction = move_direction.rotated(Vector3.UP, camera_joint.rotation.y).normalized()
	
	if Input.is_action_just_pressed("sprint"): 
		speed = SPRINT_SPEED
	if Input.is_action_just_released("sprint"): 
		speed = RUN_SPEED
	
	if move_direction:
		velocity.x = move_toward(velocity.x, move_direction.x * speed, ACCELLERATION)
		velocity.z = move_toward(velocity.z, move_direction.z * speed, ACCELLERATION)
	else:
		velocity.x = move_toward(velocity.x, 0, FRICTION)
		velocity.z = move_toward(velocity.z, 0, FRICTION)

	animation_tree.set("parameters/idle_run_blend/blend_amount", Vector2(velocity.x, velocity.z).length() / RUN_SPEED)
	move_and_slide()
	
	if velocity.length() > 0.2:
		var look_direction = Vector2(velocity.z, velocity.x)
		model.rotation.y = lerp_angle(model.rotation.y, look_direction.angle(), ACCELLERATION)
	
func _process(delta: float) -> void:
	camera_joint.position = position
