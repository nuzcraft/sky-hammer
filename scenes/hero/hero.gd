extends CharacterBody3D
class_name Hero

signal attack_landed(area, strength, pos)

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

enum HERO_STATE{
	SHEATHED,
	SHEATHING,
	UNSHEATHED,
	UNSHEATHING,
	UNSHEATH_ATTACKING
}
var STATE = HERO_STATE.SHEATHED

func _physics_process(delta: float) -> void:
	if not is_on_floor():
		velocity += get_gravity() * delta

	match STATE:
		HERO_STATE.SHEATHED:
			moveable_state()
		HERO_STATE.SHEATHING:
			stopped_state()
		HERO_STATE.UNSHEATHED:
			moveable_state()
		HERO_STATE.UNSHEATHING:
			stopped_state()
		HERO_STATE.UNSHEATH_ATTACKING:
			stopped_state()
	
func _process(delta: float) -> void:
	camera_joint.position = position
	
func moveable_state() -> void:
	var move_direction := Vector3.ZERO
	move_direction.x = Input.get_action_strength("right") - Input.get_action_strength("left")
	move_direction.z = Input.get_action_strength("down") - Input.get_action_strength("up")
	move_direction = move_direction.rotated(Vector3.UP, camera_joint.rotation.y).normalized()
	
	if Input.is_action_just_pressed("sprint"): 
		speed = SPRINT_SPEED
	if Input.is_action_just_released("sprint") and STATE == HERO_STATE.SHEATHED: 
		speed = RUN_SPEED
	
	if move_direction:
		velocity.x = move_toward(velocity.x, move_direction.x * speed, ACCELLERATION)
		velocity.z = move_toward(velocity.z, move_direction.z * speed, ACCELLERATION)
	else:
		velocity.x = move_toward(velocity.x, 0, FRICTION)
		velocity.z = move_toward(velocity.z, 0, FRICTION)

	animation_tree.set("parameters/idle_run_blend/blend_amount", min(Vector2(velocity.x, velocity.z).length() / RUN_SPEED, 1.0))
	animation_tree.set("parameters/idle_run_blend2/blend_amount", min(Vector2(velocity.x, velocity.z).length() / RUN_SPEED, 1.0))
	move_and_slide()
	
	if velocity.length() > 0.2:
		var look_direction = Vector2(velocity.z, velocity.x)
		model.rotation.y = lerp_angle(model.rotation.y, look_direction.angle(), ACCELLERATION)
		
	if Input.is_action_just_pressed("attack"):
		match STATE:
			HERO_STATE.SHEATHED:
				if velocity.length() < 0.2:
					animation_tree.set("parameters/unsheath_shot/request", AnimationNodeOneShot.ONE_SHOT_REQUEST_FIRE)
					STATE = HERO_STATE.UNSHEATHING
				else:
					animation_tree.set("parameters/unsheath_attack_shot/request", AnimationNodeOneShot.ONE_SHOT_REQUEST_FIRE)
					STATE = HERO_STATE.UNSHEATH_ATTACKING
				animation_tree.set("parameters/sheath_state/transition_request", "unsheathed")
				animation_tree.set("parameters/idle_run_blend/blend_amount", 0)
				animation_tree.set("parameters/idle_run_blend2/blend_amount", 0)
	elif Input.is_action_just_pressed("sheath"):
		match STATE:
			HERO_STATE.UNSHEATHED:
				animation_tree.set("parameters/sheath_shot/request", AnimationNodeOneShot.ONE_SHOT_REQUEST_FIRE)
				animation_tree.set("parameters/sheath_state/transition_request", "sheathed")
				animation_tree.set("parameters/idle_run_blend/blend_amount", 0)
				animation_tree.set("parameters/idle_run_blend2/blend_amount", 0)
				STATE = HERO_STATE.SHEATHING
			
func stopped_state() -> void:
	match STATE:
		HERO_STATE.SHEATHING:
			if not animation_tree.get("parameters/sheath_shot/active"):
				STATE = HERO_STATE.SHEATHED
		HERO_STATE.UNSHEATHING:
			if not animation_tree.get("parameters/unsheath_shot/active"):
				STATE = HERO_STATE.UNSHEATHED
		HERO_STATE.UNSHEATH_ATTACKING:
			if not animation_tree.get("parameters/unsheath_attack_shot/active"):
				STATE = HERO_STATE.UNSHEATHED
			await get_tree().create_timer(0.5).timeout
			$HeroModel/UnsheathAttackArea.monitoring = true
			await get_tree().create_timer(0.3).timeout
			$HeroModel/UnsheathAttackArea.monitoring = false

func _on_unsheath_attack_area_area_entered(area: Area3D) -> void:
	#$HeroModel/UnsheathAttackArea.set_deferred("monitoring", false)
	var pos = (area.global_position + $HeroModel/UnsheathAttackArea.global_position) / 2
	pos.y += 0.5
	attack_landed.emit(area, 20, pos)
