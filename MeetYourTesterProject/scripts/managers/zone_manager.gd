extends Node
# class_name ZoneManager

const zones_scene = preload ("res://ui/main_screen/progress_bar/progress_bar_zones_scene.tscn")
# FIFO queue to store created zones with their parameters
var zones_queue = []

# This needs to be set in the where the manager is used
var zones_container = null
var zone_dictionary = {}
var zone_colors = ["red", "green"]
var zone_sizes = ["sm", "md", "lg"]
	
func _init():
	print("ZoneManager initialized")
	
func _ready():
	for color in zone_colors:
		zone_dictionary[color] = {}
		for size in zone_sizes:
			zone_dictionary[color][size] = load("res://images/main-game/progress-bar/" + color + "-zone-" + size + ".svg")

# if current progress is in the first zone
func is_inside_zone(position_bar: int):
	return is_zone_present() and zones_queue[0]["start_pos"] < position_bar and position_bar < zones_queue[0]["end_pos"]

func is_zone_present():
	return len(zones_queue) > 0
# create a new zone and push it at the end of the queue
func create_zone(zone_effects: Dictionary):
	print("zone_control: Creating zone")
	var zone_texture_node = TextureRect.new()
	set_zone_texture(zone_texture_node, zone_effects)
	var new_zone = set_new_zone_properties(zone_effects, zone_texture_node)
	add_zone_to_queue_and_container(new_zone, zone_texture_node)
	print("zone_control: Zone created: %s" % new_zone)

# set zone texture based on length (sm,md,lg)
func set_zone_texture(new_zone_node, zone_effects):
	var zone_length = int(zone_effects.get("length", ProgressBarGlobals.progress_bar_zone_length.SMALL))
	var zone_speedup = zone_effects.get("zone").get("speedValue", null)
	assert(zone_speedup != null, "zone_control: Zone speedup not set")
	print("zone_control: Zone speedup: %s" % zone_speedup)
	var zone_color = "red" if zone_speedup < 1 else "green"
	match zone_length:
		ProgressBarGlobals.progress_bar_zone_length.SMALL:
			new_zone_node.texture = zone_dictionary[zone_color]["sm"]
		ProgressBarGlobals.progress_bar_zone_length.MEDIUM:
			new_zone_node.texture = zone_dictionary[zone_color]["md"]
		ProgressBarGlobals.progress_bar_zone_length.LARGE:
			new_zone_node.texture = zone_dictionary[zone_color]["lg"]
		_:
			print("Unrecognized zone length: %s" % zone_length)

# set new zone's properties
func set_new_zone_properties(zone_effects, new_zone_node):
	print("zone_effects: %s" % zone_effects)
	var new_zone = {}
	var zone_key = zone_effects.get("zone")
	var zone_offset = zone_key.get("offset", 0)
	var zone_speedup = zone_key.get("speedValue", null)
	assert(zone_speedup != null, "zone_control: Zone speedup not set")
	new_zone["speed"] = zone_speedup
	print("Zone queue capacity: %d" % len(zones_queue), "Progess bar value: %d" % ProgressBarGlobals.get_current_progressbar_value())
	new_zone["start_pos"] = zone_offset + (zones_queue[- 1]["end_pos"] if is_zone_present() else ProgressBarGlobals.get_current_progressbar_value())
	new_zone["end_pos"] = new_zone["start_pos"] + new_zone_node.texture.get_width()
	new_zone_node.offset_left = new_zone["start_pos"]
	return new_zone

# add new zone to queue and ZonesContainer
func add_zone_to_queue_and_container(new_zone, new_zone_node):
	if new_zone["end_pos"] <= zones_container.size.x:
		zones_container.add_child(new_zone_node)
		zones_queue.append(new_zone)
	else:
		push_warning("zone_control: Zone not added to container, out of bounds")

func remove_zone():
	var zone = zones_container.get_child(0)
	zones_container.remove_child(zone)
	zones_queue.pop_front()
