extends Node

@onready var progress_bar = $"../../../ProgressBarControl"

func _ready():
	pass

func float_to_time(seconds_float: float = 0) -> String:
	# var hours = int(seconds_float / 3600)
	var minutes = int(seconds_float / 60) % 60
	var seconds = int(seconds_float) % 60

	# Format the time components to ensure two digits for each (e.g., 05 instead of 5)
	# var time_string = "%02d:%02d:%02d" % [hours, minutes, seconds]
	var time_string = "%02d:%02d" % [ minutes, seconds]
	return time_string

# Connected via Editor
func _on_timer_node_timeout() -> void:
	Globals.gameTime += 1
	# increment progress bar value 
	progress_bar.auto_increment()
	self.text = float_to_time(Globals.gameTime)

func catch_pause() -> void:
	$TimerNode.paused = true
	
func catch_unpause() -> void:
	$TimerNode.paused = false

func catch_speed_change() -> void:
	#$TimerNode.wait_time = float(1) / Globals.gameSpeed
	Engine.time_scale = Globals.gameSpeed
	
