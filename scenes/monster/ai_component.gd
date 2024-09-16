extends Node
class_name AIComponent

@onready var navigation_agent_3d: NavigationAgent3D = $"../NavigationAgent3D"
@onready var idle_timer: Timer = $IdleTimer

enum AI_STATE {
	IDLE,
	PURSUING,
	#ATTACKING,
}

enum ACTION_STATE {
	IDLE,
	WALKING,
}

var current_ai_state = AI_STATE.IDLE
var current_action_state = ACTION_STATE.IDLE
var target: Vector3

func pursuing_state():
	current_ai_state = AI_STATE.PURSUING
	
func idle_state():
	current_ai_state = AI_STATE.IDLE

func set_idle_target() -> void:
	var random_position := Vector3.ZERO
	random_position.x = randf_range(-20.0, 20.0)
	random_position.z = randf_range(-20.0, 20.0)
	navigation_agent_3d.target_position = random_position
	current_action_state = ACTION_STATE.WALKING
	
func set_target() -> void:
	if target:
		current_ai_state = AI_STATE.PURSUING
		navigation_agent_3d.target_position = target
		current_action_state = ACTION_STATE.WALKING
	else:
		current_ai_state = AI_STATE.IDLE
		set_idle_target()

func _on_idle_timer_timeout() -> void:
	match current_ai_state:
		AI_STATE.IDLE:
			set_idle_target()
		AI_STATE.PURSUING:
			set_target()
	
func target_reached() -> void:
	match current_ai_state:
		AI_STATE.IDLE:
			idle_timer.start(8.0)
			current_action_state = ACTION_STATE.IDLE
		AI_STATE.PURSUING:
			idle_timer.start(4.0)
			current_action_state = ACTION_STATE.IDLE
