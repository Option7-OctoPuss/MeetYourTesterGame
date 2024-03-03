extends Node

func float_to_time(seconds_float: float = 0) -> String:
	# var hours = int(seconds_float / 3600)
	var minutes = int(seconds_float / 60) % 60
	var seconds = int(seconds_float) % 60

	# Format the time components to ensure two digits for each (e.g., 05 instead of 5)
	# var time_string = "%02d:%02d:%02d" % [hours, minutes, seconds]
	var time_string = "%02d:%02d" % [ minutes, seconds]
	return time_string
