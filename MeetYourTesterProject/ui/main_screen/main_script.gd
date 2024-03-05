extends Node

signal escape_pressed
signal pause_game
# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if Input.is_action_just_pressed("show_prompt"):
		Globals.gamePaused = true
		print("Esc pressed signal emitted")
		pause_game.emit()		
		escape_pressed.emit()
	pass
