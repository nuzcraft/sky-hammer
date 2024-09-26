extends Node
class_name CombatComponent

signal died

@export var max_health: int

@onready var health: int = max_health

func _ready() -> void:
	pass

func take_damage(amount: int) -> void:
	health -= amount
	if health <= 0:
		die()
		
func die() -> void:
	died.emit()
	
func get_attack_amount(attack_value: int) -> int:
	return 80 * attack_value
