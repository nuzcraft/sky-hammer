extends Node
class_name AIComponent

signal attack

@onready var navigation_agent_3d: NavigationAgent3D = $"../NavigationAgent3D"
@onready var idle_timer: Timer = $IdleTimer

var rng = RandomNumberGenerator.new()

enum AI_STATE {
	IDLE,
	PURSUING,
}

enum ACTION_STATE {
	IDLE,
	WALKING,
	ATTACKING,
}

var current_ai_state = AI_STATE.IDLE
var current_action_state = ACTION_STATE.IDLE
var target: Vector3

func _ready() -> void:
	rng.randomize()

func pursuing_state():
	current_ai_state = AI_STATE.PURSUING
	
func idle_state():
	current_ai_state = AI_STATE.IDLE

func set_idle_target() -> void:
	var random_position := Vector3.ZERO
	random_position.x = rng.randf_range(-12.5, 12.5)
	random_position.z = rng.randf_range(-25.0, 25.0)
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
			idle_timer.start(rng.randf_range(6.5, 8.5))
			current_action_state = ACTION_STATE.IDLE
		AI_STATE.PURSUING:
			attack.emit()
			idle_timer.start(rng.randf_range(3.5, 4.5))
			current_action_state = ACTION_STATE.IDLE
