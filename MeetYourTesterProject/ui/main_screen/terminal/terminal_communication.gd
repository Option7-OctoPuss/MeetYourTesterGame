extends Node2D

@export var event_name:String = ""

# Called when the node enters the scene tree for the first time.
func _ready():
	# list of all hexagons
	var hex_list = [
		$"../../MainControl/Database",
		$"../../MainControl/Delivery",
		$"../../MainControl/Business_Logic",
		$"../../MainControl/Backend",
		$"../../MainControl/UI_UX"
	]
	
	var MainControl = $"../../MainControl"
	
	# read and parse all questions from different data files for each node (in JSON)
	for node in ["Database","Delivery","Business_Logic","Backend","UI_UX","GutTest"]:
		var file = FileAccess.get_file_as_string("%s/%s.json" % [Globals.questions_dir_path, node])
		if file:
			Globals.questions[node] = JSON.parse_string(file)
		else:
			Globals.questions[node] = []
	# connect terminal to each hexagon in game scene
	for hex in hex_list:
		hex.connect("hexagon_clicked", handle_event_from_action_event)
	MainControl.connect("selectedAnotherAnswer", handle_test)

func handle_test(params):
	$terminal_content.handle_multiple_question(params)

func handle_event_from_action_event(event_params:Dictionary):
	event_name = event_params["node_name"]
	# retrieve stored questions for this action event
	var event_questions = Globals.questions[event_name]
	# send signal to terminal to show the questions
	$terminal_content.handle_event_from_action_event(event_name,event_questions)

