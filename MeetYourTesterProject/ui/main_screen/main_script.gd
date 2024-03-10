extends Node

signal game_pause_changed

@onready var exit_menu = $ExitPrompt/exit_menu
@onready var main_control = $MainControl
@onready var timer_control = $Sprite2D
@onready var terminal_control = $Terminal
@onready var anonimity_control_node = $AnonymityBarControl
@onready var progress_bar_control_node = $ProgressBarControl

signal end_game(type)


# Called when the node enters the scene tree for the first time.
func _ready():
	exit_menu.connect("resume_from_quit_prompt", resume)
	progress_bar_control_node.connect("last_deadline_missed", handle_last_deadline_missed)
	anonimity_control_node.connect("anon_value_update", check_anonimity_value)
	progress_bar_control_node.connect("progress_bar_limit_reached", handle_progress_bar_limit_reached)

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
	if Input.is_action_just_pressed("show_prompt"):
		Globals.gamePaused = true
		print("Esc pressed signal emitted")
		game_pause_changed.emit()
		exit_menu.visible = true
		Utils.pause(main_control)
		Utils.pause(timer_control)
		Utils.pause(terminal_control)
		manageHoverNodes()
	pass

func resume():
	Globals.gamePaused = false
	exit_menu.visible = false
	game_pause_changed.emit()
	Utils.unpause(main_control)
	Utils.unpause(timer_control)
	Utils.unpause(terminal_control)
	manageHoverNodes()
	pass

func manageHoverNodes():
	get_node("MainControl").get_node("Database").handle_game_exit(exit_menu.visible)
	get_node("MainControl").get_node("Delivery").handle_game_exit(exit_menu.visible)
	get_node("MainControl").get_node("Business_Logic").handle_game_exit(exit_menu.visible)
	get_node("MainControl").get_node("Backend").handle_game_exit(exit_menu.visible)
	get_node("MainControl").get_node("UI_UX").handle_game_exit(exit_menu.visible)
	
