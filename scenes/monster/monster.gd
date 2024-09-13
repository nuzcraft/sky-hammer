extends CharacterBody3D

enum STATE {
	WAITING,
	WALKING,
}

var state = STATE.WAITING

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	$StateLabel.text = STATE.keys()[state]
