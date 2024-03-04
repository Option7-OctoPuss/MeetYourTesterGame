extends Node
var startIcon : TextureButton
var startLabel : TextureButton

var quitIcon : TextureButton
var quitLabel : TextureButton

var exitMenu: Control

# Called when the node enters the scene tree for the first time.
func _ready():
	
	startIcon = $GridContainer/StartIcon
	startLabel = $GridContainer/CenterStartLabel/StartLabel
	quitIcon = $GridContainer/QuitIcon
	quitLabel = $GridContainer/CenterQuitLabel/QuitLabel
	exitMenu = $ExitMenuControl
	
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

# for the start icon and lable 

func _on_start_game_label_pressed():
	_debug_print("Start Game Button (label) pressed")
	# TODO instead of changing scene, we can render it on top of the current one, but 
	# it requires logic to disable other buttons
	#var layer = CanvasLayer.new()
	#add_child(layer)
	#var scene = load("res://ui/menus/difficulty/diff_scene.tscn").instantiate()
	#layer.add_child(scene)
	#scene.show()
	get_tree().change_scene_to_file("res://ui/menus/difficulty/diff_scene.tscn")

func _on_start_label_mouse_entered():
	_debug_print("Start Game Button (label) on hover entered")
	if not Globals.is_pause:
		startIcon.texture_normal = ResourceLoader.load("res://images/start-scene/btn-icon-start-select.svg")
	else:
		startIcon.texture_normal = ResourceLoader.load("res://images/start-scene/btn-icon-start.svg")	
		startLabel.texture_hover = ResourceLoader.load("res://images/start-scene/btn-label-start.svg")
		
func _on_start_label_mouse_exited():
	_debug_print("Start Game Button (label) on hover exited")
	if not Globals.is_pause:	
		startIcon.texture_normal = ResourceLoader.load("res://images/start-scene/btn-icon-start.svg")
	else:
		startLabel.texture_hover =ResourceLoader.load("res://images/start-scene/btn-label-start.svg")
		startIcon.texture_normal = ResourceLoader.load("res://images/start-scene/btn-icon-start.svg")

func _on_start_icon_mouse_entered():
	_debug_print("Start Game Button (icon) on hover entered")
	if not Globals.is_pause:
		startLabel.texture_normal = ResourceLoader.load("res://images/start-scene/btn-label-start-select.svg")
	else:
		startLabel.texture_hover =ResourceLoader.load("res://images/start-scene/btn-label-start.svg")
		startIcon.texture_hover = ResourceLoader.load("res://images/start-scene/btn-icon-start.svg")	
		
func _on_start_icon_mouse_exited():
	_debug_print("Start Game Button (icon) on hover exited")
	if not Globals.is_pause:
		startLabel.texture_normal = ResourceLoader.load("res://images/start-scene/btn-label-start.svg")
	else:
		startLabel.texture_hover =ResourceLoader.load("res://images/start-scene/btn-label-start.svg")
		startIcon.texture_hover = ResourceLoader.load("res://images/start-scene/btn-icon-start.svg")

#for the quit icon and label

func _on_quit_label_pressed():
	_debug_print("Quit Game Button (label) pressed")
	Globals.is_pause = true
	exitMenu.visible = true
	Utils.pause($GridContainer) #this function disable the functionality of all the gridcontainer nodes
	quitIcon.texture_normal = ResourceLoader.load("res://images/start-scene/btn-icon-exit.svg")
	quitLabel.texture_normal = ResourceLoader.load("res://images/start-scene/btn-label-quit.svg")
	quitIcon.texture_hover = ResourceLoader.load("res://images/start-scene/btn-icon-exit.svg")
	quitLabel.texture_hover = ResourceLoader.load("res://images/start-scene/btn-label-quit.svg")

func _on_quit_icon_mouse_entered():
	_debug_print("Quit Game Button (icon) on hover entered")
	if not Globals.is_pause:
		quitLabel.texture_normal = ResourceLoader.load("res://images/start-scene/btn-label-quit-select.svg")
	else: 
		quitLabel.texture_hover = ResourceLoader.load("res://images/start-scene/btn-label-quit.svg")
		quitIcon.texture_hover = ResourceLoader.load("res://images/start-scene/btn-icon-exit.svg")
		 
func _on_quit_icon_mouse_exited():
	_debug_print("Quit Game Button (icon) on hover exited")
	if not Globals.is_pause:
		quitLabel.texture_normal = ResourceLoader.load("res://images/start-scene/btn-label-quit.svg")
	else: 
		quitLabel.texture_hover = ResourceLoader.load("res://images/start-scene/btn-label-quit.svg")
		quitIcon.texture_hover = ResourceLoader.load("res://images/start-scene/btn-icon-exit.svg")
	
func _on_quit_label_mouse_entered():
	_debug_print("Quit Game Button (label) on hover entered")
	if not Globals.is_pause:
		quitIcon.texture_normal = ResourceLoader.load("res://images/start-scene/btn-icon-exit-select.svg")
	else: 
		quitLabel.texture_hover = ResourceLoader.load("res://images/start-scene/btn-label-quit.svg")
		quitIcon.texture_hover = ResourceLoader.load("res://images/start-scene/btn-icon-exit.svg")
		
func _on_quit_label_mouse_exited():
	_debug_print("Quit Game Button (label) on hover exited")
	if not Globals.is_pause:	
		quitIcon.texture_normal = ResourceLoader.load("res://images/start-scene/btn-icon-exit.svg")
	else: 
		quitLabel.texture_hover = ResourceLoader.load("res://images/start-scene/btn-label-quit.svg")
		quitIcon.texture_hover = ResourceLoader.load("res://images/start-scene/btn-icon-exit.svg")
	
func _debug_print(msg):
	if Globals.DEBUG_MODE:
		print(msg)
