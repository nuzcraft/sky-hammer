extends CharacterBody3D

signal attack_landed

@onready var navigation_agent_3d: NavigationAgent3D = $NavigationAgent3D
@onready var model: Node3D = $ParasaurolophusModel
@onready var animation_tree: AnimationTree = $ParasaurolophusModel/AnimationTree

var movement_component: MovementComponent
var ai_component: AIComponent
var combat_component: CombatComponent

const SPEED: float = 5.0
const ACCELLERATION: float = 0.1
const FRICTION: float = 0.5

var dead = false

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	if self.has_node("MovementComponent"): movement_component = self.get_node("MovementComponent")
	if self.has_node("AIComponent"): 
		ai_component = self.get_node("AIComponent")
		ai_component.attack.connect(_on_attack)
	if self.has_node("CombatComponent"): 
		combat_component = self.get_node("CombatComponent")
		combat_component.died.connect(_on_died)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
	
func _physics_process(delta: float) -> void:
	if not dead:
		if movement_component:
			velocity = movement_component.move(global_position)
		
		animation_tree.set("parameters/idle_walk_blend/blend_amount", min(Vector2(velocity.x, velocity.z).length() / SPEED, 1.0))
		move_and_slide()
	
		if velocity.length() > 0.2:
			var look_direction = Vector2(velocity.z, velocity.x)
			model.rotation.y = lerp_angle(model.rotation.y, look_direction.angle(), ACCELLERATION)
	#if velocity.length() < 0.01:
		#navigation_agent_3d.target_reached.emit()

#func _unhandled_input(event: InputEvent) -> void:
	#if event.is_action_pressed("ui_accept"):
		#animation_tree.set("parameters/death_state/transition_request", "dead")
		#if ai_component:
			#match ai_component.current_ai_state:
				#ai_component.AI_STATE.IDLE:
					#ai_component.pursuing_state()
				#ai_component.AI_STATE.PURSUING:
					#ai_component.idle_state()
		#print(ai_component.AI_STATE.keys()[ai_component.current_ai_state])
		#var random_position := Vector3.ZERO
		#random_position.x = randf_range(-20.0, 20.0)
		#random_position.z = randf_range(-20.0, 20.0)
		#navigation_agent_3d.target_position = random_position
		
func set_target(pos: Vector3):
	if ai_component and is_instance_valid(ai_component):
		ai_component.target = pos

func _on_navigation_agent_3d_target_reached() -> void:
	if ai_component and is_instance_valid(ai_component):
		ai_component.target_reached()

func take_damage(amount: int) -> void:
	if combat_component and is_instance_valid(combat_component):
		combat_component.take_damage(amount)
		if ai_component:
			match ai_component.current_ai_state:
				ai_component.AI_STATE.IDLE:
					ai_component.pursuing_state()
		
func _on_died() -> void:
	animation_tree.set("parameters/death_state/transition_request", "dead")
	combat_component.queue_free()
	movement_component.queue_free()
	ai_component.queue_free()
	dead = true
	await get_tree().create_timer(60).timeout
	queue_free()
	
func _on_attack() -> void:
	animation_tree.set("parameters/attack_shot/request", AnimationNodeOneShot.ONE_SHOT_REQUEST_FIRE)
	$Hitbox.monitoring = true
	await get_tree().create_timer(0.3).timeout
	$Hitbox.monitoring = false


func _on_hitbox_area_entered(area: Area3D) -> void:
	if area.get_parent() != self:
		$Hitbox.monitoring = false
		var pos = (area.global_position + $Hitbox.global_position) / 2
		pos.y += 0.5
		pos.z += 1.0
		if combat_component and is_instance_valid(combat_component):
			attack_landed.emit(area, combat_component.get_attack_amount(15), pos)
