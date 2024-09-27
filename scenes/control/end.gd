extends Control

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
	if OS.get_name() == "Web":
		$VBoxContainer/HBoxContainer/QuitButton.hide()
		$VBoxContainer/HBoxContainer/Control.hide()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _on_restart_button_pressed() -> void:
	var MAIN = load("res://main.tscn")
	get_tree().change_scene_to_packed(MAIN)


func _on_quit_button_pressed() -> void:
	get_tree().quit()
