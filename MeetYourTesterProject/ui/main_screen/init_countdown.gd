extends Timer

@onready var play_pause_btn = $"../../../../Sprite2D/TimerContainer/PlayPauseBtn"
@onready var speed_up_btn = $"../../../../Sprite2D/TimerContainer/SpeedUpBtn"
@onready var terminal = $"../../../../Terminal/_terminal_mock/terminal_content"
@onready var main_game_scene = $"../../../.."
@onready var gestore_timer = $"../../../../PauseBar/Label/TimerPause" 

var action_event_flag_pause = false
@onready var hex_parent = get_parent().get_parent()
# Called when the node enters the scene tree for the first time.
func _ready():
	randomize()
	self.wait_time = randi() % Globals.randomTimerForActionEventInactivity
	self.start()
	play_pause_btn.connect("pause_game", stop_resume_timer)
	main_game_scene.connect("game_pause_changed", stop_resume_timer)
	play_pause_btn.connect("unpause_game", stop_resume_timer)
	terminal.connect("answer_signal", handle_answer_stop_resume)
	hex_parent.connect("hexagon_clicked", handle_hexagon_click)
	gestore_timer.connect("unpause_game_timer", stop_resume_timer)
	
func _process(_delta):
	if Globals.DEBUG_MODE:
		send_time_to_label()

func handle_answer_stop_resume(answer_impact: Dictionary):
	if answer_impact.node_name == hex_parent.name:
		action_event_flag_pause = false
		stop_resume_timer()
		print(hex_parent.name)

func handle_hexagon_click(params):
	action_event_flag_pause = true
	stop_resume_timer()
	
func handle_cancel():
	action_event_flag_pause = false
	stop_resume_timer()

func stop_resume_timer():
	self.set_paused(Globals.gamePaused or action_event_flag_pause)

func send_time_to_label():
	var sub_str = "" 
	if self.time_left > 9:
		sub_str = str(self.time_left).substr(0, 2)
	else:
		sub_str = str(self.time_left).substr(0, 3)
		
	get_parent().text = sub_str

