extends Control

@onready var terminal = $"../Terminal/_terminal_mock/terminal_content"
const PROGRESS_BAR_DICTIONARY_KEY = "progress_bar"
const PROGRESS_BAR_VALUE_DICTIONARY_KEY = "value"
const PROGRESS_BAR_ZONE_DICTIONARY_KEY = "zone"
var zones_scene = preload("res://ui/main_screen/progress_bar_zones_scene.tscn")
var zones_queue = [] # FIFO queue to store created zones with their parameters

func _ready():
	terminal.connect("answer_signal", apply_progress_bar_effects)

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
	# if bar has reached the end, print GAME OVER 
	if $GameProgressBar.value >= $GameProgressBar.max_value:
	# TODO add an actual end game notification, stopping the game timer
		print("GAME OVER: progress bar has reached 100%")
	if is_inside_zone(get_current_position()):
		$GameProgressBar.value += Globals.progress_bar_speed * zones_queue[0]["speed"]
	else:
		$GameProgressBar.value += Globals.progress_bar_speed

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
	

# create a new zone and push it at the end of the queue
func create_zone(zone_effects: Dictionary):
	var new_zone_scene = zones_scene.instantiate()
	var new_zone_node:TextureRect = new_zone_scene.get_child(0)
	# https://www.davcri.it/posts/godot-reparent-node/
	new_zone_scene.remove_child(new_zone_node)
	# get zone effects and params
	var zone_length = int(zone_effects.get("length",Globals.progress_bar_zone_length.SMALL))
	match zone_length: 		# set zone texture based on length (sm,md,lg)
		Globals.progress_bar_zone_length.SMALL:
			new_zone_node.texture = preload("res://images/main-game/progress-bar/blue-zone-sm.svg")
		Globals.progress_bar_zone_length.MEDIUM:
			new_zone_node.texture = preload("res://images/main-game/progress-bar/blue-zone-md.svg")
		Globals.progress_bar_zone_length.LARGE:
			new_zone_node.texture = preload("res://images/main-game/progress-bar/blue-zone-lg.svg")
		_:
			print("Unrecognized zone length: %s" % zone_length)
	var new_zone = {}
	# set offset from left of progress bar
	var zone_offset = zone_effects.get("offset",0)
	new_zone["speed"] = zone_effects.get("speedValue",1)
	# start position is the offset (if any) plus the end of the last zone (if present) or the current progress bar position
	new_zone["start_pos"] = zone_offset + (zones_queue[-1]["end_pos"] if is_zone_present() else $GameProgressBar.value)
	# end position is the start of this zone plus the zone length
	new_zone["end_pos"] = new_zone["start_pos"] + new_zone_node.texture.get_width()
	new_zone_node.offset_left = new_zone["start_pos"]
	
	# if the end_zone of the zone will exceed the total ZonesContainer size, do not add zone
	if new_zone["end_pos"] <= $ZonesContainer.size.x: 
		$ZonesContainer.add_child(new_zone_node)
		zones_queue.append(new_zone) 
	

func remove_zone():
	var zone = $ZonesContainer.get_child(0)
	$ZonesContainer.remove_child(zone)
	zones_queue.pop_front()
	$GameProgressBar.texture_progress = load("res://images/main-game/progress-bar/yellow-bars-neutral.svg")
