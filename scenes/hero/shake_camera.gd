extends Camera3D

@export var period: float = 0.2
@export var magnitude: float = 0.2

func _camera_shake():
	var initial_transform = self.transform
	var elapsed_time = 0.0
	
	while elapsed_time < period:
		var mag = magnitude * ((period - elapsed_time) / period)
		var offset = Vector3(
			randf_range(-mag, mag),
			randf_range(-mag, mag),
			0.0
		)
		
		self.transform.origin = initial_transform.origin + offset
		elapsed_time += get_process_delta_time()
		await get_tree().process_frame
		
	self.transform = initial_transform
