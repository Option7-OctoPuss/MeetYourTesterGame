extends Node

func float_to_time(seconds_float: float = 0) -> String:
	# var hours = int(seconds_float / 3600)
	var minutes = int(seconds_float / 60) % 60
	var seconds = int(seconds_float) % 60
	
	# Format the time components to ensure two digits for each (e.g., 05 instead of 5)
	# var time_string = "%02d:%02d:%02d" % [hours, minutes, seconds]
	var time_string = "%02d:%02d" % [ minutes, seconds]
	return time_string

# on any node
func pause(node_name: Node):
	#process_mode = PROCESS_MODE_DISABLED
	node_name.process_mode = PROCESS_MODE_DISABLED
	
func unpause(node_name: Node):
	#process_mode = PROCESS_MODE_INHERIT
	node_name.process_mode = PROCESS_MODE_INHERIT

func toggle_button_effect(button: TextureButton):
	# toggle the hover and normal effect of a texture button
	# if the texture name contains "-select"
	#	- set hover effect value as the normal one
	#	- override the normal one in case of previously changed
	# else
	#	- set the expected values
	 
	if button.texture_hover.resource_path.contains("-select"):
		var split_texture = button.texture_hover.resource_path.split("-select")
		button.texture_hover = ResourceLoader.load("%s.svg" % split_texture[0])
		button.texture_normal = ResourceLoader.load("%s.svg" % split_texture[0])
	else:
		var split_texture = button.texture_hover.resource_path.split(".")
		button.texture_normal = ResourceLoader.load(button.texture_normal.resource_path)
		button.texture_hover = ResourceLoader.load("%s-select.svg" % split_texture[0])
