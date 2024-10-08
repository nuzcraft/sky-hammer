extends Node3D

@export var strength: int
@onready var cpu_particles_3d: CPUParticles3D = $CPUParticles3D

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	cpu_particles_3d.amount = 12
	cpu_particles_3d.initial_velocity_min = 2
	cpu_particles_3d.initial_velocity_max = 3
	cpu_particles_3d.amount *= (float(strength) / float(100)) + 1.0
	#cpu_particles_3d.speed_scale += (float(strength*3) / 100) + 0.5
	cpu_particles_3d.initial_velocity_max += (float(strength * 3) / 100)
	cpu_particles_3d.emitting = true

func _on_cpu_particles_3d_finished() -> void:
	queue_free()
