extends Node


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
	
func _debug_print(msg):
	if Globals.DEBUG_MODE:
		print(msg)

func _on_cancel_btn_pressed():
	_debug_print("Cancel Button pressed")
	get_tree().change_scene_to_file("res://ui/menus/main_menu.tscn")
# For now, cancelling switch the scene, so it will start from the begenning

func _on_exit_btn_pressed():
	_debug_print("Quit the game")
	get_tree().quit()
