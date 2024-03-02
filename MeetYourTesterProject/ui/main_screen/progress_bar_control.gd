extends Control

@onready var terminal = $"../Terminal/_terminal_mock/terminal_content"
const PROGRESS_BAR_DICTIONARY_KEY = "progress_bar"
const PROGRESS_BAR_VALUE_DICTIONARY_KEY = "value"
const PROGRESS_BAR_ZONE_DICTIONARY_KEY = "zone"
var zones_scene = preload("res://ui/main_screen/progress_bar_zones_scene.tscn")
var deadline_scene = preload("res://ui/main_screen/progress_bar_deadline_scene.tscn")
var zones_queue = [] # FIFO queue to store created zones with their parameters

var zone_dictionary = {}
var colors = ["red", "green"]
var sizes = ["sm", "md", "lg"]




func _ready():
	terminal.connect("answer_signal", apply_progress_bar_effects)
	for color in colors:
		zone_dictionary[color] = {}
		for size in sizes:
			zone_dictionary[color][size] = load("res://images/main-game/progress-bar/" + color + "-zone-" + size + ".svg")
	create_deadlines()
			
func _process(delta):
	if is_zone_present():
		var position_bar = get_current_position()
		# check if bar is currently inside a spawned zone, then change its speed
		if is_inside_zone(position_bar):
			$GameProgressBar.texture_progress = load("res://images/main-game/progress-bar/yellow-bars-faster.svg")
		# check if bar has passed a spawned zone, then remove it
		if position_bar > zones_queue[0]["end_pos"]:
				remove_zone()

func is_zone_present():
	return len(zones_queue) > 0

# if current progress is in the first zone
func is_inside_zone(position_bar:int):
	return is_zone_present() and zones_queue[0]["start_pos"] < position_bar and position_bar < zones_queue[0]["end_pos"]
	
func get_current_position():
	return get_pixel_from_percent($GameProgressBar.value , $GameProgressBar.size['x'])
	
func get_pixel_from_percent(percent: float, total: int) -> int:
	return int(percent * total / 100)
		
# called by the game timer each cycle, increment bar progress by default and apply zone modifier
func auto_increment():
	$ProgressBarSpeedDbg.set_text(str($GameProgressBar.value))
	# if bar has reached the end, print GAME OVER 
	if $GameProgressBar.value >= $GameProgressBar.max_value:
	# TODO add an actual end game notification, stopping the game timer
		print("GAME OVER: progress bar has reached 100%")
	if is_inside_zone(get_current_position()):
		$GameProgressBar.value += Globals.progress_bar_speed * zones_queue[0]["speed"]
	else:
		$GameProgressBar.value += Globals.progress_bar_speed
	decrease_deadlines_timers()

# get effects from answer and apply them (moving progress, creating zone)
func apply_progress_bar_effects(selected_answer: Dictionary):
	print("apply_progress_bar_effects")
	if selected_answer.has(PROGRESS_BAR_DICTIONARY_KEY):
		var effect = selected_answer[PROGRESS_BAR_DICTIONARY_KEY]
		if effect.has(PROGRESS_BAR_VALUE_DICTIONARY_KEY):
			# Godot handle under the hood the check for progress bar boundaries. If you add 1000 with a max value of 100 it will be 100.
			$GameProgressBar.value += effect[PROGRESS_BAR_VALUE_DICTIONARY_KEY]
		if effect.has(PROGRESS_BAR_ZONE_DICTIONARY_KEY):
			create_zone(effect[PROGRESS_BAR_ZONE_DICTIONARY_KEY])

func float_to_time(seconds_float: float = 0) -> String:
	var minutes = int(seconds_float / 60) % 60
	var seconds = int(seconds_float) % 60

	# Format the time components to ensure two digits for each (e.g., 05 instead of 5)
	# var time_string = "%02d:%02d:%02d" % [hours, minutes, seconds]
	var time_string = "%02d:%02d" % [ minutes, seconds]
	return time_string

func create_deadlines():
	for i in range(len(Globals.deadlines)):
		var new_deadline_scene = deadline_scene.instantiate()
		var tmp_key = "deadline_%s" % str(i)
		new_deadline_scene.get_child(0).set_text(float_to_time(float(Globals.deadlines[i][tmp_key].deadline_position_in_seconds)))
		new_deadline_scene.position.x = (Globals.deadlines[i][tmp_key].deadline_position_in_seconds * Globals.progress_bar_speed / 100 * $GameProgressBar.size.x) - new_deadline_scene.get_child(1).size.x
		$DeadlinesContainer.add_child(new_deadline_scene)
		
func decrease_deadlines_timers():
	for i in range(len($DeadlinesContainer.get_children())):
		var tmp_key = "deadline_%s" % str(i)
		var new_timer = float(Globals.deadlines[i][tmp_key].deadline_position_in_seconds - Globals.gameTime)
		if new_timer < 0:
			continue
		$DeadlinesContainer.get_child(i).get_child(0).set_text(float_to_time(new_timer))

# create a new zone and push it at the end of the queue
func create_zone(zone_effects: Dictionary):
	var new_zone_node = create_new_zone_node()
	set_zone_texture(new_zone_node, zone_effects)
	var new_zone = set_new_zone_properties(zone_effects, new_zone_node)
	add_zone_to_queue_and_container(new_zone, new_zone_node)

# create a new zone scene and node
func create_new_zone_node():
	var new_zone_scene = zones_scene.instantiate()
	var new_zone_node:TextureRect = new_zone_scene.get_child(0)
	new_zone_scene.remove_child(new_zone_node)
	return new_zone_node

# set zone texture based on length (sm,md,lg)
func set_zone_texture(new_zone_node, zone_effects):
	var zone_length = int(zone_effects.get("length",Globals.progress_bar_zone_length.SMALL))
	var zone_speedup = zone_effects.get("speedValue",1)
	var zone_color = "red" if zone_speedup < 1 else "green"
	match zone_length:
		Globals.progress_bar_zone_length.SMALL:
			new_zone_node.texture = zone_dictionary[zone_color]["sm"]
		Globals.progress_bar_zone_length.MEDIUM:
			new_zone_node.texture = zone_dictionary[zone_color]["md"]
		Globals.progress_bar_zone_length.LARGE:
			new_zone_node.texture = zone_dictionary[zone_color]["lg"]
		_:
			print("Unrecognized zone length: %s" % zone_length)

# set new zone's properties
func set_new_zone_properties(zone_effects, new_zone_node):
	var new_zone = {}
	var zone_offset = zone_effects.get("offset",0)
	new_zone["speed"] = zone_effects.get("speedValue",1)
	new_zone["start_pos"] = zone_offset + (zones_queue[-1]["end_pos"] if is_zone_present() else $GameProgressBar.value)
	new_zone["end_pos"] = new_zone["start_pos"] + new_zone_node.texture.get_width()
	new_zone_node.offset_left = new_zone["start_pos"]
	return new_zone

# add new zone to queue and ZonesContainer
func add_zone_to_queue_and_container(new_zone, new_zone_node):
	if new_zone["end_pos"] <= $ZonesContainer.size.x: 
		$ZonesContainer.add_child(new_zone_node)
		zones_queue.append(new_zone)

func remove_zone():
	var zone = $ZonesContainer.get_child(0)
	$ZonesContainer.remove_child(zone)
	zones_queue.pop_front()
	$GameProgressBar.texture_progress = load("res://images/main-game/progress-bar/yellow-bars-neutral.svg")
