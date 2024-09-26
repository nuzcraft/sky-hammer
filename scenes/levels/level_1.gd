extends Node3D
class_name Level1

signal portal_entered

@onready var portal: Node3D = $Portal

 #Called when the node enters the scene tree for the first time.
func _ready() -> void:
	portal.body_entered.connect(_on_body_entered_portal)

func _on_body_entered_portal(body: Node3D) -> void:
	portal_entered.emit(body, self)
