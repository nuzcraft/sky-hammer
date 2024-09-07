extends Node3D

@onready var hero = $Hero
@onready var camera: Camera3D = hero.get_node("CameraJoint").get_node("Camera3D")

const BLOOD = preload("res://scenes/blood.tscn")
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	hero.attack_landed.connect(_on_hero_attack_landed)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func _on_hero_attack_landed(area: Area3D, strength: int, pos: Vector3) -> void:
	camera.magnitude = ((strength / 100) * 0.25) + .05
	camera._camera_shake()
	var blood = BLOOD.instantiate()
	blood.strength = strength
	blood.position = pos
	add_child(blood)
	hit_stop(strength)

func hit_stop(strength: int) -> void:
	var new_time_scale = (100 - (min(strength, 100) * 0.9)) / 100
	Engine.time_scale = new_time_scale
	await get_tree().create_timer(0.1).timeout
	get_tree().create_tween().tween_property(Engine, "time_scale", 1.0, 0.2)	
	
