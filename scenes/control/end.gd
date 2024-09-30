extends Control

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
	if OS.get_name() == "Web":
		$VBoxContainer/HBoxContainer/QuitButton.hide()
		$VBoxContainer/HBoxContainer/Control.hide()
	SoundPlayer.transition_music(SoundPlayer.MENU_LOOP)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _on_restart_button_pressed() -> void:
	var MAIN = load("res://main.tscn")
	SoundPlayer.play_sound(SoundPlayer.CLICK_1)
	get_tree().change_scene_to_packed(MAIN)


func _on_quit_button_pressed() -> void:
	SoundPlayer.play_sound(SoundPlayer.CLICK_1)
	get_tree().quit()

func _on_button_mouse_entered() -> void:
	SoundPlayer.play_sound(SoundPlayer.ROLLOVER_2)
