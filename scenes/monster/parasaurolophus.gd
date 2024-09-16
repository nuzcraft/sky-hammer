extends CharacterBody3D

@onready var navigation_agent_3d: NavigationAgent3D = $NavigationAgent3D
@onready var model: Node3D = $ParasaurolophusModel
@onready var animation_tree: AnimationTree = $ParasaurolophusModel/AnimationTree

var movement_component: MovementComponent
var ai_component: AIComponent

const SPEED: float = 5.0
const ACCELLERATION: float = 0.1
const FRICTION: float = 0.5

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	if self.has_node("MovementComponent"): movement_component = self.get_node("MovementComponent")
	if self.has_node("AIComponent"): ai_component = self.get_node("AIComponent")

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
	
func _physics_process(delta: float) -> void:
	if movement_component:
		velocity = movement_component.move(global_position)
	
	animation_tree.set("parameters/idle_walk_blend/blend_amount", min(Vector2(velocity.x, velocity.z).length() / SPEED, 1.0))
	move_and_slide()
	
	if velocity.length() > 0.2:
		var look_direction = Vector2(velocity.z, velocity.x)
		model.rotation.y = lerp_angle(model.rotation.y, look_direction.angle(), ACCELLERATION)
	#if velocity.length() < 0.01:
		#navigation_agent_3d.target_reached.emit()

func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed("ui_accept"):
		if ai_component:
			match ai_component.current_ai_state:
				ai_component.AI_STATE.IDLE:
					ai_component.pursuing_state()
				ai_component.AI_STATE.PURSUING:
					ai_component.idle_state()
		print(ai_component.AI_STATE.keys()[ai_component.current_ai_state])
		#var random_position := Vector3.ZERO
		#random_position.x = randf_range(-20.0, 20.0)
		#random_position.z = randf_range(-20.0, 20.0)
		#navigation_agent_3d.target_position = random_position
		
func set_target(pos: Vector3):
	if ai_component:
		ai_component.target = pos

func _on_navigation_agent_3d_target_reached() -> void:
	if ai_component:
		ai_component.target_reached()
