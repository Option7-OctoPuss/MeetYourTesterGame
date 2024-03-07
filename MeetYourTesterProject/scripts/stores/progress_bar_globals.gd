extends Node

const progress_bar_path = "res://ui/main_screen/progress_bar/progress_bar.tscn"
const progress_bar_scene = preload (progress_bar_path)

enum progress_bar_zone_length {
	SMALL = 1,
	MEDIUM = 2,
	LARGE = 3,
}
var progress_bar_possible_speeds = [0.3, 0.6, 1] # a value is chosen based on selected difficulty
var progress_bar_speed = progress_bar_possible_speeds[0]
var _progress_bar_ref = null
var array_names = ["MainGameScene", "ProgressBar", "ProgressFrame", "GameProgressBar"]

func get_progress_bar_ref() -> Node:
	if _progress_bar_ref == null:
		_progress_bar_ref = __get_progress_bar_reference()
	return _progress_bar_ref

func __get_progress_bar_reference() -> Node:
	print("get_progress_bar_ref: getting root")
	var root = get_tree().get_root()
	print("get_progress_bar_ref: getting main_game_scene from ", root)
	var main_game_scene = root.get_node(array_names[0])
	print("get_progress_bar_ref: getting progress_bar from ", main_game_scene)
	var progress_bar = main_game_scene.get_node(array_names[1])
	print("get_progress_bar_ref: getting progress_frame from ", progress_bar)
	var progress_frame = progress_bar.get_node(array_names[2])
	print("get_progress_bar_ref: getting game_progress_bar from ", progress_frame)
	var game_progress_bar = progress_frame.get_node(array_names[3])
	print("get_progress_bar_ref: returning game_progress_bar")
	return game_progress_bar
	
	# return get_tree().get_root().get_node(array_names[0]).get_node(array_names[1]).get_node(array_names[2]).get_node(array_names[3])

### This return the VALUE of the progress bar, not the PIXELS
func get_current_progressbar_value() -> float:
	return get_progress_bar_ref().value

### This return the PIXELS of the progress bar, not the VALUE
func get_current_progressbar_pixels() -> float:
	return (get_current_progressbar_value() / 100) * get_progress_bar_ref().size.x
