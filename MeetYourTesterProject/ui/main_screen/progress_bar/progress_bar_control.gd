extends Control

const PROGRESS_BAR_DICTIONARY_KEY = "progress_bar"
const PROGRESS_BAR_VALUE_DICTIONARY_KEY = "value"
const PROGRESS_BAR_ZONE_DICTIONARY_KEY = "zone"
var zones_scene = preload ("res://ui/main_screen/progress_bar/progress_bar_zones_scene.tscn")
var deadline_scene = preload ("res://ui/main_screen/progress_bar/progress_bar_deadline_scene.tscn")
var zones_queue = [] # FIFO queue to store created zones with their parameters

var zone_dictionary = {}
var zone_colors = ["red", "green"]
var zone_sizes = ["sm", "md", "lg"]
var deadline_dictionary = {}
var deadline_states = ["missed", "reached"]
var game_progress_bar_node = null

func _ready():
	var parent_scene_node = get_tree().get_root()
	var parent_scene = parent_scene_node.get_node("MainGameScene")
	var terminal = parent_scene.get_node("Terminal")
	
	terminal.connect("answer_signal", apply_progress_bar_effects)
	game_progress_bar_node = self.get_node("ProgressFrame").get_node("GameProgressBar")
	
	for color in zone_colors:
		zone_dictionary[color] = {}
		for size in zone_sizes:
			zone_dictionary[color][size] = load("res://images/main-game/progress-bar/" + color + "-zone-" + size + ".svg")
	for state in deadline_states:
		deadline_dictionary[state] = load("res://images/main-game/progress-bar/deadline-" + state + ".svg")
	create_deadlines()
	init_last_deadline_label()
			
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
func is_inside_zone(position_bar: int):
	return is_zone_present() and zones_queue[0]["start_pos"] < position_bar and position_bar < zones_queue[0]["end_pos"]
	
func get_current_position():
	return get_pixel_from_percent(game_progress_bar_node.value, game_progress_bar_node.size['x'])
	
func get_pixel_from_percent(percent: float, total: int) -> int:
	return int(percent * total / 100)
		
# called by the game timer each cycle, increment bar progress by default and apply zone modifier
func auto_increment():
	$ProgressBarSpeedDbg.set_text(str(game_progress_bar_node.value))
	# if bar has reached the end, print GAME OVER 
	if game_progress_bar_node.value >= game_progress_bar_node.max_value:
	# TODO add an actual end game notification, stopping the game timer
		print("GAME OVER: progress bar has reached 100%")
	if is_inside_zone(get_current_position()):
		game_progress_bar_node.value += Globals.progress_bar_speed * zones_queue[0]["speed"]
	else:
		game_progress_bar_node.value += Globals.progress_bar_speed
	decrease_deadlines_timers()

# get effects from answer and apply them (moving progress, creating zone)
func apply_progress_bar_effects(selected_answer: Dictionary):
	print("apply_progress_bar_effects")
	if selected_answer.has(PROGRESS_BAR_DICTIONARY_KEY):
		var effect = selected_answer[PROGRESS_BAR_DICTIONARY_KEY]
		if effect.has(PROGRESS_BAR_VALUE_DICTIONARY_KEY):
			# Godot handle under the hood the check for progress bar boundaries. If you add 1000 with a max value of 100 it will be 100.
			game_progress_bar_node.value += effect[PROGRESS_BAR_VALUE_DICTIONARY_KEY]
		if effect.has(PROGRESS_BAR_ZONE_DICTIONARY_KEY):
			create_zone(effect[PROGRESS_BAR_ZONE_DICTIONARY_KEY])

func init_last_deadline_label():
	# last label is max value of the progress bar / current step size
	$FinalDeadlineLabel.set_text(Utils.float_to_time(float(game_progress_bar_node.max_value / Globals.progress_bar_speed)))

# This function creates a new deadline scene and returns it
func create_new_deadline_scene():
	return deadline_scene.instantiate()

# This function calculates the position of the new deadline scene
func calculate_position(deadline_position_in_seconds, progress_bar_speed, game_progress_bar_size, deadline_scene_size):
	return ((deadline_position_in_seconds * progress_bar_speed) / 100) * game_progress_bar_size

func create_deadlines():
	for i in range(len(Globals.deadlines)):
		var new_deadline_scene = create_new_deadline_scene()
		var current_key = "deadline_%s" % str(i)
		var deadline_position_in_seconds = float(Globals.deadlines[i][current_key].deadline_position_in_seconds)
		
		# Set the text of the first child of the new deadline scene
		new_deadline_scene.get_child(0).set_text(Utils.float_to_time(deadline_position_in_seconds))
		# Calculate the position of the new deadline scene
		new_deadline_scene.position.x = calculate_position(deadline_position_in_seconds, Globals.progress_bar_speed, game_progress_bar_node.size.x, new_deadline_scene.get_child(1).size.x)
		print("new_deadline_scene position: ", new_deadline_scene.position.x, "new_deadline_scene size: ", new_deadline_scene.get_child(1).size.x, " name: ", new_deadline_scene.get_child(1).name)
		# Add the new deadline scene to the DeadlinesContainer
		$DeadlinesContainer.add_child(new_deadline_scene)

func is_deadline_reached(deadline_index: int) -> bool:
	# var progress_frame_border = game_progress_bar_node.position.x
	var percentage_position = (game_progress_bar_node.value / game_progress_bar_node.max_value) * game_progress_bar_node.size.x
	var deadline_scene = $DeadlinesContainer.get_child(deadline_index)
	var list_of_children = $DeadlinesContainer.get_children()
	# for child in list_of_children:
	# 	print("child scene position: ", deadline_scene.position.x, " child image size: ", child.get_node("Deadline").size.x, " name: ", child.get_node("Deadline").name)
	# print("deadline position: ", dead line.position.x, "deadline size: ", deadline.size.x, deadline)
	var deadline_instance = $DeadlinesContainer.get_child(deadline_index).get_node("Deadline")
	var far_right_deadline_position = deadline_scene.position.x + deadline_instance.size.x
	var offset = 10
	print("far_right_deadline_position: ", far_right_deadline_position, "percentage_position: ", percentage_position)
	# var border_offset = $ProgressFrame.position.x

	return percentage_position >= far_right_deadline_position - offset

func decrease_deadlines_timers():
	if $FinalDeadlineLabel.get_text() == "00:00":
		return
		
	$FinalDeadlineLabel.set_text(Utils.float_to_time(float((game_progress_bar_node.max_value / Globals.progress_bar_speed) - Globals.gameTime)))
	for i in range(len($DeadlinesContainer.get_children())):
		var current_key = "deadline_%s" % str(i)
		var new_timer = float(Globals.deadlines[i][current_key].deadline_position_in_seconds - Globals.gameTime)
		var deadline_label = $DeadlinesContainer.get_child(i).get_child(0)
		var deadline_texture = $DeadlinesContainer.get_child(i).get_child(1)
		
		# check if the texture is already changed
		if deadline_texture.texture.resource_path.contains("missed") or deadline_texture.texture.resource_path.contains("reached"):
			continue
		
		if new_timer <= 0:
			# check if the current position of the progress bar is less than the position of the next deadline
			if not is_deadline_reached(i):
				deadline_texture.texture = deadline_dictionary["missed"]
				# Here is the logic for sabotagge button

			else:
				deadline_texture.texture = deadline_dictionary["reached"]
		else:
			if is_deadline_reached(i):
				deadline_texture.texture = deadline_dictionary["reached"]
				
		deadline_label.set_text(Utils.float_to_time(new_timer))

# create a new zone and push it at the end of the queue
func create_zone(zone_effects: Dictionary):
	var new_zone_node = create_new_zone_node()
	set_zone_texture(new_zone_node, zone_effects)
	var new_zone = set_new_zone_properties(zone_effects, new_zone_node)
	add_zone_to_queue_and_container(new_zone, new_zone_node)

# create a new zone scene and node
func create_new_zone_node():
	var new_zone_scene = zones_scene.instantiate()
	var new_zone_node: TextureRect = new_zone_scene.get_child(0)
	new_zone_scene.remove_child(new_zone_node)
	return new_zone_node

# set zone texture based on length (sm,md,lg)
func set_zone_texture(new_zone_node, zone_effects):
	var zone_length = int(zone_effects.get("length", Globals.progress_bar_zone_length.SMALL))
	var zone_speedup = zone_effects.get("speedValue", 1)
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
	var zone_offset = zone_effects.get("offset", 0)
	new_zone["speed"] = zone_effects.get("speedValue", 1)
	new_zone["start_pos"] = zone_offset + (zones_queue[- 1]["end_pos"] if is_zone_present() else game_progress_bar_node.value)
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
	game_progress_bar_node.texture_progress = load("res://images/main-game/progress-bar/yellow-bars-neutral.svg")
