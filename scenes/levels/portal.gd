extends Node3D
signal body_entered

func _on_area_3d_body_entered(body: Node3D) -> void:
	body_entered.emit(body)
