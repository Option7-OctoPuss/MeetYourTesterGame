extends Node
var startIcon : TextureButton
var startLabel : TextureButton

var quitIcon : TextureButton
var quitLabel : TextureButton


# Called when the node enters the scene tree for the first time.
func _ready():
	
	startIcon = $GridContainer/StartIcon
	startLabel = $GridContainer/CenterStartLabel/StartLabel
	quitIcon = $GridContainer/QuitIcon
	quitLabel = $GridContainer/CenterQuitLabel/QuitLabel
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
	startIcon.texture_normal = ResourceLoader.load("res://images/start-scene/btn-icon-start-select.svg")

func _on_start_label_mouse_exited():
	_debug_print("Start Game Button (label) on hover exited")
	startIcon.texture_normal = ResourceLoader.load("res://images/start-scene/btn-icon-start.svg")

func _on_start_icon_mouse_entered():
	_debug_print("Start Game Button (icon) on hover entered")
	startLabel.texture_normal = ResourceLoader.load("res://images/start-scene/btn-label-start-select.svg")

func _on_start_icon_mouse_exited():
	_debug_print("Start Game Button (icon) on hover exited")
	startLabel.texture_normal = ResourceLoader.load("res://images/start-scene/btn-label-start.svg")

#for the quit icon and label

func _on_quit_label_pressed():
	_debug_print("Quit Game Button (label) pressed")
	# TODO instead of changing scene, we can render it on top of the current one, but 
	# it requires logic to disable other buttons
	#var layer = CanvasLayer.new()
	#add_child(layer)
	#var scene = load("res://ui/menus/difficulty/diff_scene.tscn").instantiate()
	#layer.add_child(scene)
	#scene.show()

	#add_myNode_to_my_game()
	get_tree().change_scene_to_file("res://ui/menus/exit_menu_scene.tscn")
	

func _on_quit_icon_mouse_entered():
	_debug_print("Quit Game Button (icon) on hover entered")
	quitLabel.texture_normal = ResourceLoader.load("res://images/start-scene/btn-label-quit-select.svg")
	 
func _on_quit_icon_mouse_exited():
	_debug_print("Quit Game Button (icon) on hover exited")
	quitLabel.texture_normal = ResourceLoader.load("res://images/start-scene/btn-label-quit.svg")


func _on_quit_label_mouse_entered():
	_debug_print("Quit Game Button (label) on hover entered")
	quitIcon.texture_normal = ResourceLoader.load("res://images/start-scene/btn-icon-exit-select.svg")
	

func _on_quit_label_mouse_exited():
	_debug_print("Quit Game Button (label) on hover exited")
	quitIcon.texture_normal = ResourceLoader.load("res://images/start-scene/btn-icon-exit.svg")
	
#func add_myNode_to_my_game():
#	var exit_menu_scene = preload("res://ui/menus/exit_menu_scene.tscn")
#	var exit_menu_instance = exit_menu_scene.instance()
#	get_tree().get_root().add_child(exit_menu_instance)

func _debug_print(msg):
	if Globals.DEBUG_MODE:
		print(msg)
