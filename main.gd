extends Node3D

@onready var hero = $Hero
@onready var camera: Camera3D = hero.get_node("CameraJoint").get_node("Camera3D")
@onready var health_bar: ProgressBar = $CanvasLayer/HBoxContainer/HealthBar

const BLOOD = preload("res://scenes/blood.tscn")
const LEVEL_1 = preload("res://scenes/levels/level_1.tscn")
const PARASAUROLOPHUS = preload("res://scenes/monster/parasaurolophus.tscn")
const END = preload("res://scenes/control/end.tscn")

enum LEVEL {
	ONE,
	TWO,
	THREE
}

var current_level = LEVEL.ONE
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	hero.attack_landed.connect(_on_hero_attack_landed)
	hero.died.connect(_on_hero_died)
	health_bar.value = hero.get_health()
	start_level()
	
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	for enemy in get_tree().get_nodes_in_group("Enemies"):
		enemy.set_target(hero.global_position)

func _on_hero_attack_landed(area: Area3D, strength: int, pos: Vector3) -> void:
	camera.magnitude = ((strength / 100) * 0.25) + .05
	camera.period = 0.2
	if strength > 60: camera.period /= 2
	camera._camera_shake()
	var blood = BLOOD.instantiate()
	blood.strength = strength
	blood.position = pos
	var enemy = area.get_parent()
	enemy.take_damage(60 * (strength * .01))
	add_child(blood)
	hit_stop(strength)
	
func _on_enemy_attack_landed(area: Area3D, strength: int, pos: Vector3) -> void:
	var blood = BLOOD.instantiate()
	blood.strength = strength / 80
	blood.position = pos
	add_child(blood)
	var other = area.get_parent()
	if other is Hero: 
		other.take_damage(strength / 80)
	else:
		other.take_damage(strength / 80)
	health_bar.value = hero.get_health()

func hit_stop(strength: int) -> void:
	var new_time_scale = (100 - (min(strength, 100) * 0.9)) / 100
	Engine.time_scale = new_time_scale
	var amount = 0.3
	if strength > 60: amount /= 2
	await get_tree().create_timer(0.1).timeout
	get_tree().create_tween().tween_property(Engine, "time_scale", 1.0, amount)	
	
func start_level() -> void:
	match current_level:
		LEVEL.ONE:
			var level = LEVEL_1.instantiate()
			add_child(level)
			level.portal_entered.connect(_on_level_portal_entered)
			hero.position = Vector3(17.5, 1.12, 22)
			var para1 = PARASAUROLOPHUS.instantiate()
			para1.attack_landed.connect(_on_enemy_attack_landed)
			add_child(para1)
			para1.position = Vector3(-8.5, 1, -16.5)
			var para2 = PARASAUROLOPHUS.instantiate()
			para2.attack_landed.connect(_on_enemy_attack_landed)
			add_child(para2)
			para2.position = Vector3(5, 1, -14)
			var para3 = PARASAUROLOPHUS.instantiate()
			para3.attack_landed.connect(_on_enemy_attack_landed)
			add_child(para3)
			para3.position = Vector3(-1.5, 1, -8)
	
func _on_level_portal_entered(body: Node3D, level: Node3D) -> void:
	if level is Level1:
		if body is Hero:
			get_tree().change_scene_to_packed(END)
			
func _on_hero_died() -> void:
	print("hero died")
	get_tree().change_scene_to_packed(END)
