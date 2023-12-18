extends Node
var easyIcon : TextureButton
var easyLabel : TextureButton
var mediumIcon : TextureButton
var mediumLabel : TextureButton
var hardIcon : TextureButton
var hardLabel : TextureButton
var cancelIcon : TextureButton
var cancelLabel : TextureButton

# Called when the node enters the scene tree for the first time.
func _ready():
	easyIcon = $GridContainer2/EasyDiffIcon
	easyLabel = $GridContainer2/CenterContainer/EasyDiffBtn
	mediumIcon = $GridContainer2/MediumDiffIcon
	mediumLabel = $GridContainer2/CenterContainer2/MediumDiffBtn
	hardIcon = $GridContainer2/HardDiffIcon
	hardLabel = $GridContainer2/CenterContainer3/HardDiffBtn
	cancelIcon = $GridContainer2/CancelIcon
	cancelLabel = $GridContainer2/CenterContainer4/CancelBtn


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func _on_easy_mouse_entered():
	_debug_print("Easy Game Button (label) on hover entered")
	easyIcon.texture_normal = ResourceLoader.load("res://images/start-scene/btn-icon-easy-select.svg")
	easyLabel.texture_normal = ResourceLoader.load("res://images/start-scene/btn-label-easy-select.svg")

func _on_easy_mouse_exited():
	_debug_print("Easy Game Button (label) on hover entered")
	easyIcon.texture_normal = ResourceLoader.load("res://images/start-scene/btn-icon-easy.svg")
	easyLabel.texture_normal = ResourceLoader.load("res://images/start-scene/btn-label-easy.svg")
	
func _on_medium_mouse_entered():
	_debug_print("Medium Game Button (label) on hover entered")
	mediumIcon.texture_normal = ResourceLoader.load("res://images/start-scene/btn-icon-medium-select.svg")
	mediumLabel.texture_normal = ResourceLoader.load("res://images/start-scene/btn-label-medium-select.svg")
	
func _on_medium_mouse_exited():
	_debug_print("Medium Game Button (label) on hover entered")
	mediumIcon.texture_normal = ResourceLoader.load("res://images/start-scene/btn-icon-medium.svg")
	mediumLabel.texture_normal = ResourceLoader.load("res://images/start-scene/btn-label-medium.svg")

func _on_hard_mouse_entered():
	_debug_print("Hard Game Button (label) on hover entered")
	hardIcon.texture_normal = ResourceLoader.load("res://images/start-scene/btn-icon-hard-select.svg")
	hardLabel.texture_normal = ResourceLoader.load("res://images/start-scene/btn-label-hard-select.svg")

func _on_hard_mouse_exited():
	_debug_print("Hard Game Button (label) on hover entered")
	hardIcon.texture_normal = ResourceLoader.load("res://images/start-scene/btn-icon-hard.svg")
	hardLabel.texture_normal = ResourceLoader.load("res://images/start-scene/btn-label-hard.svg")
	
func _on_cancel_mouse_entered():
	_debug_print("Cancel Game Button (label) on hover entered")
	cancelIcon.texture_normal = ResourceLoader.load("res://images/start-scene/btn-icon-cancel-select.svg")
	cancelLabel.texture_normal = ResourceLoader.load("res://images/start-scene/btn-label-cancel-select.svg")
	
func _on_cancel_mouse_exited():
	_debug_print("Cancel Game Button (label) on hover entered")
	cancelIcon.texture_normal = ResourceLoader.load("res://images/start-scene/btn-icon-cancel.svg")
	cancelLabel.texture_normal = ResourceLoader.load("res://images/start-scene/btn-label-cancel.svg")

func _debug_print(msg):
	if Globals.DEBUG_MODE:
		print(msg)
