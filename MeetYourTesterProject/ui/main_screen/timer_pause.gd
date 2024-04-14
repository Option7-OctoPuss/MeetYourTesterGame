extends Node
var availablePauseTime = 30

@onready var timerPause = $TimerPause
signal update_pause_game_timer(time)
# Called when the node enters the scene tree for the first time.
func _ready():
	if Globals.current_difficulty_level == 1:
		availablePauseTime = 90 
	elif Globals.current_difficulty_level == 2:
			availablePauseTime = 60
	else: 
		availablePauseTime = 30
	Globals.max_pause_time = availablePauseTime
	self.text = str(availablePauseTime)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
	
func stop_timer(value):
	timerPause.paused = value
	

func _on_timer_node_timeout():
	if availablePauseTime > 0 && Globals.gamePaused && not Globals.menuOpen:
		availablePauseTime -= 1
		self.text = str(availablePauseTime) + " s"
		if availablePauseTime == 0:
			Globals.gamePaused = false
			Globals.isPausable = false
		update_pause_game_timer.emit(availablePauseTime)
			
