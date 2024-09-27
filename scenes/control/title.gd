extends Control

const MAIN = preload("res://main.tscn")
const CREDITS = preload("res://scenes/control/credits.tscn")
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
	SoundPlayer.transition_music(SoundPlayer.MENU_LOOP)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _on_button_pressed() -> void:
	get_tree().change_scene_to_packed(MAIN)
	SoundPlayer.play_sound(SoundPlayer.CLICK_1)


func _on_button_2_pressed() -> void:
	get_tree().change_scene_to_packed(CREDITS)
	SoundPlayer.play_sound(SoundPlayer.CLICK_1)


func _on_volume_slider_value_changed(value: float) -> void:
	var fl = value * .01
	AudioServer.set_bus_volume_db(AudioServer.get_bus_index("Master"), linear_to_db(fl))


func _on_volume_slider_drag_ended(value_changed: bool) -> void:
	SoundPlayer.play_sound(SoundPlayer.CLICK_1)

func _on_button_mouse_entered() -> void:
	SoundPlayer.play_sound(SoundPlayer.ROLLOVER_2)
