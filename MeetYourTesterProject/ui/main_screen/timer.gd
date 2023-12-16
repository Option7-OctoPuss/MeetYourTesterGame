extends Node

var timerObj = null
var dateTime = null

func _ready():
	timerObj = $TimerNode
	timerObj.wait_time = 1
	timerObj.start()

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
	self.text = float_to_time(Globals.gameTime)

func catch_pause() -> void:
	timerObj.paused = true
	
func catch_unpause() -> void:
	timerObj.paused = false

func catch_speed_change() -> void:
	print("Speed change")
	timerObj.wait_time = float(1) / Globals.gameSpeed