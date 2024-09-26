extends SpringArm3D

@export var mouse_sensitivity := 0.1
@export var controller_sensitivity := 3.0

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	set_as_top_level(true)
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
	rotation_degrees.y = 90
	rotation_degrees.x = -20
	
func _physics_process(delta: float) -> void:
	var vec := Vector2.ZERO
	vec.x = Input.get_action_strength("camera_right") - Input.get_action_strength("camera_left")
	vec.y = Input.get_action_strength("camera_down") - Input.get_action_strength("camera_up")
	if vec != Vector2.ZERO:
		rotation_degrees.x -= vec.y * controller_sensitivity
		rotation_degrees.x = clamp(rotation_degrees.x, -90.0, 30.0)
		rotation_degrees.y -= vec.x * controller_sensitivity
		rotation_degrees.y = wrapf(rotation_degrees.y, 0.0, 360.0)

func _unhandled_input(event: InputEvent) -> void:
	if event is InputEventMouseMotion:
		rotation_degrees.x -= event.relative.y * mouse_sensitivity
		rotation_degrees.x = clamp(rotation_degrees.x, -90.0, 30.0)
		
		rotation_degrees.y -= event.relative.x * mouse_sensitivity
		rotation_degrees.y = wrapf(rotation_degrees.y, 0.0, 360.0)
		#print(event.relative)
	elif event is InputEventMouseButton:
		Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
		
	#elif event is InputEventJoypadMotion:
		#var vec := Vector2.ZERO
		#vec.x = Input.get_action_strength("camera_left") - Input.get_action_strength("camera_right")
		#vec.y = Input.get_action_strength("camera_up") - Input.get_action_strength("camera_down")
		#if vec != Vector2.ZERO:
			#rotation_degrees.x -= vec.y * controller_sensitivity
			#rotation_degrees.x = clamp(rotation_degrees.x, -90.0, 30.0)
			#
			#rotation_degrees.y -= vec.x * controller_sensitivity
			#rotation_degrees.y = wrapf(rotation_degrees.y, 0.0, 360.0)
