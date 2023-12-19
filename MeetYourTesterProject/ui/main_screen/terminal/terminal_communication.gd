extends Node2D


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func handle_event_from_action_event(_args):
	print("hello world from terminal: " + _args)
	$terminal_content.handle_event_from_action_event(_args)
