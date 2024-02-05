extends Timer

@onready var play_pause_btn = $"../../../../Sprite2D/TimerContainer/PlayPauseBtn"
@onready var speed_up_btn = $"../../../../Sprite2D/TimerContainer/SpeedUpBtn"

# Called when the node enters the scene tree for the first time.
func _ready():
	randomize()
	self.wait_time = randi() % Globals.randomTimerForActionEventInactivity
	self.start()
	play_pause_btn.connect("pause_game", stop_resume_timer)
	play_pause_btn.connect("unpause_game", stop_resume_timer)
	
func _process(_delta):
	if Globals.DEBUG_MODE:
		send_time_to_label()

func stop_resume_timer():
	self.set_paused(!self.paused)

func send_time_to_label():
	var sub_str = "" 
	if self.time_left > 9:
		sub_str = str(self.time_left).substr(0, 2)
	else:
		sub_str = str(self.time_left).substr(0, 3)
		
	get_parent().text = sub_str

