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

func get_progress_bar_ref() -> Node:
	if _progress_bar_ref == null:
		_progress_bar_ref = __get_progress_bar_reference()
	return _progress_bar_ref

func __get_progress_bar_reference() -> Node:
	const array_names = ["MainGameScene", "ProgressBar", "ProgressFrame", "GameProgressBar"]
	return get_tree().get_root().get_node(array_names[0]).get_node(array_names[1]).get_node(array_names[2]).get_node(array_names[3])

### This return the VALUE of the progress bar, not the PIXELS
func get_current_progressbar_value() -> float:
	return get_progress_bar_ref().value

### This return the PIXELS of the progress bar, not the VALUE
func get_current_progressbar_pixels() -> float:
	return (get_current_progressbar_value() / 100) * get_progress_bar_ref().size.x
