extends Node

@onready var progress_bar = $"../../../ProgressBarControl"
@onready var main_game_scene = $"../../.."
@onready var timer_handler = $"../../../PauseBar/TimeAvailable"

func _ready():
	main_game_scene.connect("game_pause_changed", catch_pause_changed)
	timer_handler.connect("update_pause_game_timer", update_pause_game_timer)

func update_pause_game_timer(time):
	if time == 0:
		catch_pause_changed()

# Connected via Editor
func _on_timer_node_timeout() -> void:
	Globals.gameTime += 1
	# increment progress bar value 
	progress_bar.auto_increment()
	self.text = Utils.float_to_time(Globals.gameTime)

func catch_pause_changed() -> void:
	if Globals.gamePaused:
		catch_pause()
	else:
		catch_unpause()

func catch_pause() -> void:
	$TimerNode.paused = true
	
func catch_unpause() -> void:
	$TimerNode.paused = false

func catch_speed_change() -> void:
	#$TimerNode.wait_time = float(1) / Globals.gameSpeed
	Engine.time_scale = Globals.gameSpeed
	
