@tool
extends Node3D

@export var rotate_x: bool = false
@export var rotate_y: bool = true
@export var rotate_z: bool = false
@export var min_rot: int = -180
@export var max_rot: int = 180
@export var scale_x: bool = true
@export var scale_y: bool = true
@export var scale_z: bool = true
@export var scale_same: bool = false
@export var min_scale: float = 0.8
@export var max_scale: float = 1.2
@export var randomize: bool = false : set = set_button

var rng = RandomNumberGenerator.new()

func set_button(new_value: bool) -> void:
	if rotate_x: rotation_degrees.x = randf_range(min_rot, max_rot)
	if rotate_y: rotation_degrees.y = randf_range(min_rot, max_rot)
	if rotate_z: rotation_degrees.z = randf_range(min_rot, max_rot)
	if scale_same: 
		var s = randf_range(min_scale, max_scale)
		scale = Vector3(s, s, s)
	else:
		if scale_x: scale.x = randf_range(min_scale, max_scale)
		if scale_y: scale.y = randf_range(min_scale, max_scale)
		if scale_z: scale.z = randf_range(min_scale, max_scale)
