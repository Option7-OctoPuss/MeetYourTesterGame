extends Node

signal resume_from_quit_prompt

# Called when the node enters the scene tree for the first time.
func _ready():
	pass
	
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
	
func _debug_print(msg):
	if Globals.DEBUG_MODE:
		print(msg)

func _on_cancel_btn_pressed():
	_debug_print("Cancel Button pressed")
	emit_signal("resume_from_quit_prompt")

# For now, cancelling switch the scene, so it will start from the begenning
func _on_exit_btn_pressed():
	_debug_print("Back to main menu")
	get_tree().change_scene_to_file("res://ui/menus/main_menu.tscn")
	

