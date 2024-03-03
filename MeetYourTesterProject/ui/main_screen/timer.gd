extends Node

@onready var progress_bar = $"../../../ProgressBarControl"

func _ready():
	pass

# Connected via Editor
func _on_timer_node_timeout() -> void:
	Globals.gameTime += 1
	# increment progress bar value 
	progress_bar.auto_increment()
	self.text = Utils.float_to_time(Globals.gameTime)

func catch_pause() -> void:
	$TimerNode.paused = true
	
func catch_unpause() -> void:
	$TimerNode.paused = false

func catch_speed_change() -> void:
	#$TimerNode.wait_time = float(1) / Globals.gameSpeed
	Engine.time_scale = Globals.gameSpeed
	
