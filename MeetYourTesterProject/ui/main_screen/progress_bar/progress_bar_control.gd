extends Control

const PROGRESS_BAR_DICTIONARY_KEY = "progress_bar"
const PROGRESS_BAR_VALUE_DICTIONARY_KEY = "value"
const PROGRESS_BAR_ZONE_DICTIONARY_KEY = "zone"
const deadline_scene = preload ("res://ui/main_screen/progress_bar/progress_bar_deadline_scene.tscn")
# const ZoneManagerScript = preload ("res://ui/main_screen/progress_bar/zones/zone_control.gd")
# var zone_manager = null

var progress_bar_textures = {
	"slower": preload ("res://images/main-game/progress-bar/yellow-bars-slower.svg"),
	"neutral": preload ("res://images/main-game/progress-bar/yellow-bars-neutral.svg"),
	"faster": preload ("res://images/main-game/progress-bar/yellow-bars-faster.svg")

}

var deadline_dictionary = {}
var deadline_states = ["missed", "reached"]
var game_progress_bar_node = null
var terminal_content_node = null
func _ready():
	instantiate_scene()
	
func instantiate_scene():
	print("ready function on progress_bar_control")
	var zones_container = get_node("ProgressFrame/ZonesContainer")
	# zone_manager = ZoneManager.new(zones_container)
	ZoneManager.zones_container = zones_container
	terminal_content_node = $"../Terminal/_terminal_mock/terminal_content"
	terminal_content_node.connect("answer_signal", apply_progress_bar_effects)
	game_progress_bar_node = self.get_node("ProgressFrame").get_node("GameProgressBar")
	if game_progress_bar_node == null:
		print("Game progress bar node is null")
		push_error("Game progress bar node is null")
	for state in deadline_states:
		deadline_dictionary[state] = load("res://images/main-game/progress-bar/deadline-" + state + ".svg")
	#! PASS THE PROGRESS BAR NODE HERE SO IT CAN BE USED IN THE FUNCTION
	#! otherwise we cannot reach game_progress_bar_node.size.x in tests
	create_deadlines()
	init_last_deadline_label()
			
func _process(delta):
	if ZoneManager.is_zone_present():
		var position_bar_value = get_current_position()
		var far_right_zone_position = ZoneManager.zones_queue[0].get("end_pos", null)
		# check if bar is currently inside a spawned zone, then change its speed
		if ZoneManager.is_inside_zone(position_bar_value):
			game_progress_bar_node.texture_progress = progress_bar_textures["faster"]
		# check if bar has passed a spawned zone, then remove it
		elif position_bar_value > far_right_zone_position:
			assert(far_right_zone_position != null, "progress_bar_control: Zone end position is null")
			ZoneManager.remove_zone()
			# change the bar texture back to normal
			game_progress_bar_node.texture_progress = progress_bar_textures["neutral"]

func get_current_position():
	return get_pixel_from_percent(game_progress_bar_node.value, game_progress_bar_node.size['x'])
	
func get_pixel_from_percent(percent: float, total: int) -> float:
	return (percent * total) / 100

# called by the game timer each cycle, increment bar progress by default and apply zone modifier
func auto_increment(node_ref: Node):
	if node_ref == null:
		node_ref = game_progress_bar_node
	print("### node_ref: ", node_ref)
	$ProgressBarSpeedDbg.set_text(str(node_ref.value))
	# if bar has reached the end, print GAME OVER 
	if node_ref.value >= node_ref.max_value:
	# TODO add an actual end game notification, stopping the game timer
		print("GAME OVER: progress bar has reached 100%")
	if ZoneManager.is_inside_zone(get_current_position()):
		node_ref.value += ProgressBarGlobals.progress_bar_speed * ZoneManager.zones_queue[0]["speed"]
	else:
		node_ref.value += ProgressBarGlobals.progress_bar_speed
	print("before decrease_deadlines_timers func")
	decrease_deadlines_timers()

# get effects from answer and apply them (moving progress, creating zone)
func apply_progress_bar_effects(selected_answer: Dictionary):
	if selected_answer.has(PROGRESS_BAR_DICTIONARY_KEY):
		var effect = selected_answer[PROGRESS_BAR_DICTIONARY_KEY]
		if effect.has(PROGRESS_BAR_VALUE_DICTIONARY_KEY):
			# Godot handle under the hood the check for progress bar boundaries. If you add 1000 with a max value of 100 it will be 100.
			game_progress_bar_node.value += effect[PROGRESS_BAR_VALUE_DICTIONARY_KEY]
		if effect.has(PROGRESS_BAR_ZONE_DICTIONARY_KEY):
			ZoneManager.create_zone(effect[PROGRESS_BAR_ZONE_DICTIONARY_KEY])

func init_last_deadline_label():
	# last label is max value of the progress bar / current step size
	$FinalDeadlineLabel.set_text(Utils.float_to_time(float(game_progress_bar_node.max_value / ProgressBarGlobals.progress_bar_speed)))

# This function creates a new deadline scene and returns it
func create_new_deadline_scene():
	return deadline_scene.instantiate()

# This function calculates the position of the new deadline scene
func calculate_position(deadline_position_in_seconds, progress_bar_speed, game_progress_bar_size):
	return ((deadline_position_in_seconds * progress_bar_speed) / 100) * game_progress_bar_size

func create_deadlines():
	for i in range(len(Globals.deadlines)):
		var new_deadline_scene = create_new_deadline_scene()
		var current_key = "deadline_%s" % str(i)
		var deadline_position_in_seconds = float(Globals.deadlines[i][current_key].deadline_position_in_seconds)
		
		# Set the text of the first child of the new deadline scene
		new_deadline_scene.get_child(0).set_text(Utils.float_to_time(deadline_position_in_seconds))
		# Calculate the position of the new deadline scene
		new_deadline_scene.position.x = calculate_position(deadline_position_in_seconds, ProgressBarGlobals.progress_bar_speed, game_progress_bar_node.size.x)
		# Add the new deadline scene to the DeadlinesContainer
		print("### new deadline is added to container!")
		$DeadlinesContainer.add_child(new_deadline_scene)

func is_deadline_reached(deadline_index: int) -> bool:
	# var progress_frame_border = game_progress_bar_node.position.x
	var percentage_position = (game_progress_bar_node.value / game_progress_bar_node.max_value) * game_progress_bar_node.size.x
	var _deadline_scene = $DeadlinesContainer.get_child(deadline_index)
	var deadline_instance = $DeadlinesContainer.get_child(deadline_index).get_node("Deadline")
	var far_right_deadline_position = _deadline_scene.position.x + deadline_instance.size.x
	var offset = 10
	# var border_offset = $ProgressFrame.position.x

	return percentage_position >= far_right_deadline_position - offset

func decrease_deadlines_timers():
	if $FinalDeadlineLabel.get_text() == "00: 00":
		return
		
	$FinalDeadlineLabel.set_text(Utils.float_to_time(float((game_progress_bar_node.max_value / ProgressBarGlobals.progress_bar_speed) - Globals.gameTime)))
	var deadline_container_children = $DeadlinesContainer.get_children()
	for i in range(len(deadline_container_children)):
		var current_key = "deadline_%d" % i
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
