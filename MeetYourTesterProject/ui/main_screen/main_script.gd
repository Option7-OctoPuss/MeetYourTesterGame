extends Node

signal game_pause_changed

@onready var exit_menu = $ExitPrompt/exit_menu
@onready var main_control = $MainControl
@onready var timer_control = $Sprite2D
@onready var terminal_control = $Terminal
# Called when the node enters the scene tree for the first time.
func _ready():
	exit_menu.connect("resume_from_quit_prompt", resume)


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
	
