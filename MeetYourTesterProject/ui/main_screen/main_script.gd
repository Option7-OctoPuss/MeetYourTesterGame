extends Node

signal game_pause_changed

@onready var exit_menu = $ExitPrompt/exit_menu
@onready var return_to_main_menu = $ReturnToMainMenu/return_to_main_menu
@onready var main_control = $MainControl
@onready var timer_control = $Sprite2D
@onready var terminal_control = $Terminal
@onready var anonimity_control_node = $AnonymityBarControl
@onready var progress_bar_control_node = $ProgressBarControl
@onready var pause_menu = $PauseMenu
@onready var tutorial_scene_container = $TutorialSceneContainer
@onready var database_hexagon = $MainControl/Database
@onready var delivery_hexagon = $MainControl/Delivery
@onready var business_logic_hexagon = $MainControl/Business_Logic
@onready var backend_hexagon = $MainControl/Backend
@onready var ui_ux_hexagon = $MainControl/UI_UX
@onready var mainControl = $MainControl
@onready var timer_handler = $PauseBar/TimeAvailable
@onready var play_pause_btn = $Sprite2D/TimerContainer/PlayPauseBtn
@onready var available_pause_time_bar = $PauseBar/TextureProgressBar

var hexagons = ["Database", "Delivery", "Business_Logic", "Backend", "UI_UX"]
var restartTimerPause = false
signal end_game(type)

# Called when the node enters the scene tree for the first time.
func _ready():
	exit_menu.connect("resume_from_quit_prompt", resume)
	return_to_main_menu.connect("resume_from_quit_prompt", resume)
	progress_bar_control_node.connect("last_deadline_missed", handle_last_deadline_missed)
	anonimity_control_node.connect("anon_value_update", check_anonimity_value)
	progress_bar_control_node.connect("progress_bar_limit_reached", handle_progress_bar_limit_reached)
	pause_menu.visible = false
	pause_menu.connect("resume_game", resume)
	tutorial_scene_container.connect("resume_game", resume)
	pause_menu.connect("open_tutorial", handle_open_tutorial)
	pause_menu.connect("quit", handle_quit)
	pause_menu.connect("back_to_menu", back_to_main_menu)
	timer_handler.connect("update_pause_game_timer", handle_update_pause_game_timer)
	Globals.isPausable = true
	Globals.gameSpeed = 1
	Globals.bg_music_volume = 0
	Globals.sound_fx_volume = 0 
	Globals.menuOpen = false
	for hex in hexagons:
		mainControl.get_node(hex).connect("hexagon_clicked", handle_hexagon_clicked)
	
func handle_hexagon_clicked(params):
	for hex in hexagons:
		if params.node_name == hex:
			continue
		mainControl.get_node(hex).cancel_pressed()

func handle_update_pause_game_timer(time):
	available_pause_time_bar.value = time * 100 / Globals.max_pause_time 
	if time == 0:
		play_pause_btn.changeImage()
		for hex in hexagons:
			mainControl.get_node(hex).get_node("Label").get_node("Timer").stop_resume_timer()
	

func handle_quit():
	pause_menu.visible = false
	exit_menu.visible = true
	pass

func back_to_main_menu():
	pause_menu.visible = false
	return_to_main_menu.visible = true
	pass
	
func handle_open_tutorial():
	pause_menu.visible = false
	
	var children = $".".get_children()
	
	for i in range(0, len(children)):
		children[i].visible = false
	
	tutorial_scene_container.visible = true


func handle_last_deadline_missed():
	print("Missed last deadline, you won the game")
	Globals.end_game_reason = 1
	get_tree().change_scene_to_file("res://ui/menus/end_game_scene.tscn")
	
func check_anonimity_value():
	if Globals.current_anonymity_value <= 0:
		print("Current anonimity value reached 0, game lost")
		Globals.end_game_reason = 2
		get_tree().change_scene_to_file("res://ui/menus/end_game_scene.tscn")

func handle_progress_bar_limit_reached():
	print("Progress bar reached its limit, game lost")
	Globals.end_game_reason = 3
	get_tree().change_scene_to_file("res://ui/menus/end_game_scene.tscn")
	

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if Input.is_action_just_pressed("show_prompt") and not Globals.menuOpen:
		Globals.menuOpen = true
		if not Globals.gamePaused:
			Globals.gamePaused = true
			print("Esc pressed signal emitted")
			game_pause_changed.emit()
			Utils.pause(main_control)
			Utils.pause(timer_control)
			Utils.pause(terminal_control)
		else:
			timer_handler.stop_timer(true)
			restartTimerPause = true
			
		pause_menu.visible = true

		manageHoverNodes()
	pass

func resume():
	var children = $".".get_children()
	
	for i in range(0, len(children)):
		children[i].visible = true
	if restartTimerPause:
		print("Keep pause")
		timer_handler.stop_timer(false)
	else:
		print("Restart")
		Globals.gamePaused = false
		game_pause_changed.emit()
	
	Utils.unpause(main_control)
	Utils.unpause(timer_control)
	Utils.unpause(terminal_control)
	exit_menu.visible = false
	pause_menu.visible = false
	return_to_main_menu.visible = false
	tutorial_scene_container.visible = false
	restartTimerPause = false
	Globals.menuOpen = false
	manageHoverNodes()
	pass

func manageHoverNodes():
	print("HoverNodes")
	$MainControl/Database.handle_game_exit(exit_menu.visible || pause_menu.visible)
	$MainControl/Delivery.handle_game_exit(exit_menu.visible || pause_menu.visible)
	$MainControl/Business_Logic.handle_game_exit(exit_menu.visible || pause_menu.visible)
	$MainControl/Backend.handle_game_exit(exit_menu.visible || pause_menu.visible)
	$MainControl/UI_UX.handle_game_exit(exit_menu.visible || pause_menu.visible)
	
