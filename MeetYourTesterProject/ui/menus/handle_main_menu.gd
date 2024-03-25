extends Node
var startIcon : TextureButton
var startLabel : TextureButton

var quitIcon : TextureButton
var quitLabel : TextureButton

var exitMenu: Control

signal quit_signal

# Called when the node enters the scene tree for the first time.
func _ready():
	startIcon = $GridContainer/StartIcon
	startLabel = $GridContainer/CenterStartLabel/StartLabel
	quitIcon = $GridContainer/QuitIcon
	quitLabel = $GridContainer/CenterQuitLabel/QuitLabel
	exitMenu = $ExitMenuControl
	exitMenu.visible = false
	self.connect("quit_signal", disable_everything)
	exitMenu.get_node("exit_menu").connect("resume_from_quit_prompt",enable_everything)
	
	var config = ConfigFile.new()
	var err = config.load("./settings.cfg")
	if err == OK:
		var show_popup = config.get_value("FirstStart", "show_popup")
		if show_popup != false:
			show_tutorial_popup()
			config.set_value("FirstStart","show_popup", false)
			config.save("./settings.cfg")
	else:
		# first time that the user play (file not present)
		config.set_value("FirstStart","show_popup", false)
		config.save("./settings.cfg")
		show_tutorial_popup()

	# when `don't show again` is pressed:
	#config.set_value("startup", "show_popup", false)
	# Called every frame. 'delta' is the elapsed time since the previous frame.

func _process(delta):
	pass

func show_tutorial_popup():
	$TutorialPopup.visible = true
	
	
# for the start icon and lable 
func disable_everything():
	Utils.pause($GridContainer)
	exitMenu.visible = true
	Utils.toggle_button_effect(startIcon)
	Utils.toggle_button_effect(startLabel)
	Utils.toggle_button_effect(quitLabel)
	Utils.toggle_button_effect(quitIcon)

func enable_everything():
	Utils.unpause($GridContainer)
	exitMenu.visible = false
	Utils.toggle_button_effect(startIcon)
	Utils.toggle_button_effect(startLabel)
	Utils.toggle_button_effect(quitLabel)
	Utils.toggle_button_effect(quitIcon)

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
	if not exitMenu.visible:
		startIcon.texture_normal = ResourceLoader.load("res://images/start-scene/btn-icon-start-select.svg")	
func _on_start_label_mouse_exited():
	_debug_print("Start Game Button (label) on hover exited")
	startIcon.texture_normal = ResourceLoader.load("res://images/start-scene/btn-icon-start.svg")
		
func _on_start_icon_mouse_entered():
	_debug_print("Start Game Button (icon) on hover entered")
	if not exitMenu.visible:
		startLabel.texture_normal = ResourceLoader.load("res://images/start-scene/btn-label-start-select.svg")
		
func _on_start_icon_mouse_exited():
	_debug_print("Start Game Button (icon) on hover exited")
	startLabel.texture_normal = ResourceLoader.load("res://images/start-scene/btn-label-start.svg")

		
#for the quit icon and label

func _on_quit_label_pressed():
	_debug_print("Quit Game Button (label) pressed")
	emit_signal("quit_signal")
	
	
func _on_quit_icon_mouse_entered():
	_debug_print("Quit Game Button (icon) on hover entered")
	if not exitMenu.visible:
		quitLabel.texture_normal = ResourceLoader.load("res://images/start-scene/btn-label-quit-select.svg")
	
		
func _on_quit_icon_mouse_exited():
	_debug_print("Quit Game Button (icon) on hover exited")
	quitLabel.texture_normal = ResourceLoader.load("res://images/start-scene/btn-label-quit.svg")
	
func _on_quit_label_mouse_entered():
	_debug_print("Quit Game Button (label) on hover entered")
	if not exitMenu.visible:
		quitIcon.texture_normal = ResourceLoader.load("res://images/start-scene/btn-icon-exit-select.svg")
	
func _on_quit_label_mouse_exited():
	_debug_print("Quit Game Button (label) on hover exited")
	quitIcon.texture_normal = ResourceLoader.load("res://images/start-scene/btn-icon-exit.svg")
	
func _debug_print(msg):
	if Globals.DEBUG_MODE:
		print(msg)
