extends Node2D

@export var event_name:String = ""

# Called when the node enters the scene tree for the first time.
func _ready():
	# read and parse the question data file (in JSON)
	var file = FileAccess.get_file_as_string(Globals.questions_file_path)
	Globals.questions = JSON.parse_string(file)


func handle_event_from_action_event(event_params:Dictionary):
	event_name = event_params["node_name"]
	# retrieve stored questions for this action event
	# TODO: fix retrieval after official file structure is imported
	var event_questions = Globals.questions.nodes[0][event_name]
	
	# send signal to terminal to show the questions
	$terminal_content.handle_event_from_action_event(event_name,event_questions)

func _on_terminal_content_answer_signal(answer_target:Variant):
	Globals.currentAnswer = answer_target
	print("Current answer in store: %s" % Globals.currentAnswer)
