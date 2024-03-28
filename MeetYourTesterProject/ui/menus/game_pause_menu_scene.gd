extends Node2D
@onready var startIcon : TextureButton = $GridContainer/StartIcon
@onready var startLabel : TextureButton = $GridContainer/CenterStartLabel/StartLabel

@onready var quitIcon : TextureButton = $GridContainer/QuitIcon
@onready var quitLabel : TextureButton = $GridContainer/CenterQuitLabel/QuitLabel

@onready var tutorialIcon : TextureButton = $GridContainer/TutorialIcon
@onready var tutorialLabel : TextureButton = $GridContainer/CenterTutorialLabel/TutorialLabel

@onready var backMainMenuIcon : TextureButton = $GridContainer/BackMainMenuIcon
@onready var backMainMenuLabel : TextureButton = $GridContainer/CenterBackMainMenu/BackMainMenuLabel

signal resume_game
signal open_tutorial
signal quit

# Called when the node enters the scene tree for the first time.
func _ready():
	pass

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func _on_resume_game_pressed():
	_debug_print("Resume game")
	resume_game.emit()

func _on_start_tutorial_pressed():
	_debug_print("Start tutorial")
	open_tutorial.emit()
	
func _on_quit_pressed():
	_debug_print("Quit")
	quit.emit()
	
func _on_start_label_mouse_entered():
	_debug_print("Start Game Button (label) on hover entered")
	startIcon.texture_normal = ResourceLoader.load("res://images/pause-menu/btn-icon-return-select.svg")	

func _on_start_label_mouse_exited():
	_debug_print("Start Game Button (label) on hover exited")
	startIcon.texture_normal = ResourceLoader.load("res://images/pause-menu/btn-icon-return.svg")
		
func _on_start_icon_mouse_entered():
	_debug_print("Start Game Button (icon) on hover entered")
	startLabel.texture_normal = ResourceLoader.load("res://images/pause-menu/btn-label-return-select.svg")
		
func _on_start_icon_mouse_exited():
	_debug_print("Start Game Button (icon) on hover exited")
	startLabel.texture_normal = ResourceLoader.load("res://images/pause-menu/btn-label-return.svg")
	
func _on_quit_icon_mouse_entered():
	_debug_print("Quit Game Button (icon) on hover entered")
	quitLabel.texture_normal = ResourceLoader.load("res://images/pause-menu/btn-label-quit-select.svg")
		
func _on_quit_icon_mouse_exited():
	_debug_print("Quit Game Button (icon) on hover exited")
	quitLabel.texture_normal = ResourceLoader.load("res://images/pause-menu/btn-label-quit.svg")
	
func _on_quit_label_mouse_entered():
	_debug_print("Quit Game Button (label) on hover entered")
	quitIcon.texture_normal = ResourceLoader.load("res://images/pause-menu/btn-icon-quit-select.svg")
	
func _on_quit_label_mouse_exited():
	_debug_print("Quit Game Button (label) on hover exited")
	quitIcon.texture_normal = ResourceLoader.load("res://images/pause-menu/btn-icon-quit.svg")
	
func _on_tutorial_icon_mouse_entered():
	_debug_print("tutorial Game Button (icon) on hover entered")
	tutorialLabel.texture_normal = ResourceLoader.load("res://images/pause-menu/btn-label-tutorial-select.svg")
		
func _on_tutorial_icon_mouse_exited():
	_debug_print("tutorial Game Button (icon) on hover exited")
	tutorialLabel.texture_normal = ResourceLoader.load("res://images/pause-menu/btn-label-tutorial.svg")
	
func _on_tutorial_label_mouse_entered():
	_debug_print("tutorial Game Button (label) on hover entered")
	tutorialIcon.texture_normal = ResourceLoader.load("res://images/pause-menu/btn-icon-tutorial-select.svg")
	
func _on_tutorial_label_mouse_exited():
	_debug_print("tutorial Game Button (label) on hover exited")
	tutorialIcon.texture_normal = ResourceLoader.load("res://images/pause-menu/btn-icon-tutorial.svg")

func _on_back_main_menu_label_mouse_entered():
	_debug_print("back main menu Game Button (label) on hover entered")
	backMainMenuIcon.texture_normal = ResourceLoader.load("res://images/pause-menu/btn-icon-back-main-menu-hover.svg")
	
func _on_back_main_menu_label_mouse_exited():
	_debug_print("back main menu Game Button (label) on hover exited")
	backMainMenuIcon.texture_normal = ResourceLoader.load("res://images/pause-menu/btn-icon-back-main-menu.svg")

func _on_back_main_menu_icon_mouse_entered():
	_debug_print("back main menu Game Button (icon) on hover entered")
	backMainMenuLabel.texture_normal = ResourceLoader.load("res://images/pause-menu/btn-back-main-menu-hover.svg")
	
func _on_back_main_menu_icon_mouse_exited():
	_debug_print("back main menu Game Button (icon) on hover exited")
	backMainMenuLabel.texture_normal = ResourceLoader.load("res://images/pause-menu/btn-back-main-menu.svg")
	
func _debug_print(msg):
	if Globals.DEBUG_MODE:
		print(msg)
