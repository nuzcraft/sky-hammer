extends Control
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _on_button_pressed() -> void:
	var TITLE = load("res://scenes/control/title.tscn")
	SoundPlayer.play_sound(SoundPlayer.CLICK_1)
	get_tree().change_scene_to_packed(TITLE)


func _on_button_mouse_entered() -> void:
	SoundPlayer.play_sound(SoundPlayer.ROLLOVER_2)
