extends Node3D

@export var strength: int
@onready var cpu_particles_3d: CPUParticles3D = $CPUParticles3D

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	cpu_particles_3d.amount *= (float(strength) / 100) + 1.0
	cpu_particles_3d.speed_scale += (float(strength) / 100)
	cpu_particles_3d.emitting = true

func _on_cpu_particles_3d_finished() -> void:
	queue_free()
