extends Node3D

@onready var hero = $Hero
@onready var camera: Camera3D = hero.get_node("CameraJoint").get_node("Camera3D")

const BLOOD = preload("res://scenes/blood.tscn")
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	hero.attack_landed.connect(_on_hero_attack_landed)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	for enemy in get_tree().get_nodes_in_group("Enemies"):
		enemy.set_target(hero.global_position)

func _on_hero_attack_landed(area: Area3D, strength: int, pos: Vector3) -> void:
	# TODO add property to enemy so they only take one hit at a time
	camera.magnitude = ((strength / 100) * 0.25) + .05
	camera.period = 0.2
	if strength > 60: camera.period /= 2
	camera._camera_shake()
	var blood = BLOOD.instantiate()
	blood.strength = strength
	blood.position = pos
	add_child(blood)
	hit_stop(strength)

func hit_stop(strength: int) -> void:
	var new_time_scale = (100 - (min(strength, 100) * 0.9)) / 100
	Engine.time_scale = new_time_scale
	var amount = 0.3
	if strength > 60: amount /= 2
	await get_tree().create_timer(0.1).timeout
	get_tree().create_tween().tween_property(Engine, "time_scale", 1.0, amount)	
	
