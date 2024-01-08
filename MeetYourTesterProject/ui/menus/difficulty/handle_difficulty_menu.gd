extends Node2D

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
	easyIcon = $GridContainer/EasyIcon
	easyLabel = $GridContainer/CenterEasyLabel/EasyDiffBtn
	mediumIcon = $GridContainer/MediumIcon
	mediumLabel = $GridContainer/CenterMediumLabel/MediumDiffBtn
	hardIcon = $GridContainer/HardIcon
	hardLabel = $GridContainer/CenterHardLabel/HardDiffBtn
	cancelIcon = $GridContainer/CancelIcon
	cancelLabel = $GridContainer/CenterCancelLabel/CancelBtn

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func _on_diff_btn_mouse_entered(difficulty_level:int):
	match difficulty_level:
		0:
			cancelIcon.texture_normal = ResourceLoader.load("res://images/start-scene/btn-icon-cancel-select.svg")
			cancelLabel.texture_normal = ResourceLoader.load("res://images/start-scene/btn-label-cancel-select.svg")
		1:
			easyIcon.texture_normal = ResourceLoader.load("res://images/start-scene/btn-icon-easy-select.svg")
			easyLabel.texture_normal = ResourceLoader.load("res://images/start-scene/btn-label-easy-select.svg")
		2:
			mediumIcon.texture_normal = ResourceLoader.load("res://images/start-scene/btn-icon-medium-select.svg")
			mediumLabel.texture_normal = ResourceLoader.load("res://images/start-scene/btn-label-medium-select.svg")
		3:
			hardIcon.texture_normal = ResourceLoader.load("res://images/start-scene/btn-icon-hard-select.svg")
			hardLabel.texture_normal = ResourceLoader.load("res://images/start-scene/btn-label-hard-select.svg")
	
func _on_diff_btn_mouse_exited(difficulty_level:int):
	match difficulty_level:
		0:
			cancelIcon.texture_normal = ResourceLoader.load("res://images/start-scene/btn-icon-cancel.svg")
			cancelLabel.texture_normal = ResourceLoader.load("res://images/start-scene/btn-label-cancel.svg")
		1:
			easyIcon.texture_normal = ResourceLoader.load("res://images/start-scene/btn-icon-easy.svg")
			easyLabel.texture_normal = ResourceLoader.load("res://images/start-scene/btn-label-easy.svg")
		2:
			mediumIcon.texture_normal = ResourceLoader.load("res://images/start-scene/btn-icon-medium.svg")
			mediumLabel.texture_normal = ResourceLoader.load("res://images/start-scene/btn-label-medium.svg")
		3:
			hardIcon.texture_normal = ResourceLoader.load("res://images/start-scene/btn-icon-hard.svg")
			hardLabel.texture_normal = ResourceLoader.load("res://images/start-scene/btn-label-hard.svg")


func _on_cancel_btn_pressed():
	get_tree().change_scene_to_file("res://ui/menus/main_menu.tscn")
