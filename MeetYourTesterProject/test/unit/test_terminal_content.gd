extends GutTest

class TestTerminalContent:
	extends GutTest 
	
	var terminal_content_node_name = "terminal_content"
	var play_pause_btn = "PlayPauseBtn"
	var speed_up_btn = "SpeedUpBtn"
	var game_scene = null
	var terminal_content_node = null

	func before_all():
		gut.p('TestTerminalContent:  pre-run')
		var file = FileAccess.get_file_as_string(Globals.questions_test_file_path)
		Globals.questions = JSON.parse_string(file)

	func before_each():
		game_scene = preload("res://ui/main_screen/terminal/terminal_mock.tscn").instantiate()
		terminal_content_node = game_scene.find_child(terminal_content_node_name)

	func after_each():
		game_scene.free()

	func test_backend_node_id():
		var event_name = Globals.questions['nodes'][0].keys()[0]
		var current_question = terminal_content_node.retrieve_question(Globals.questions['nodes'][0][event_name])
		assert_eq(int(current_question.id), 1)

	func test_backend_node_single_answer_count():
		var event_name = Globals.questions['nodes'][0].keys()[0]
		var current_question = terminal_content_node.retrieve_question(Globals.questions['nodes'][0][event_name])
		assert_eq(current_question.answers.size(), 1)

	func test_backend_node_single_answer_text():
		var event_name = Globals.questions['nodes'][0].keys()[0]
		var current_question = terminal_content_node.retrieve_question(Globals.questions['nodes'][0][event_name])
		assert_eq(current_question.answers[0].text, "First answer, progress bar effect value (weight) 1, create a zone with offset 20 and length 7 and speed value of 1.5 )")
	
	func test_not_empty_terminal_content():
		var event_name = Globals.questions['nodes'][0].keys()[0]
		terminal_content_node.handle_event_from_action_event(Globals.questions['nodes'][0].keys()[0], Globals.questions['nodes'][0][event_name])
		terminal_content_node.update_terminal_content("1_0")
		assert_ne(terminal_content_node.get_text(), "")
		
	func test_terminal_contains_specific_content():
		var event_name = Globals.questions['nodes'][0].keys()[0]
		terminal_content_node.handle_event_from_action_event(Globals.questions['nodes'][0].keys()[0], Globals.questions['nodes'][0][event_name])
		terminal_content_node.update_terminal_content("1_0")
		assert_string_contains(terminal_content_node.get_text(), "First answer, progress bar effect value (weight) 1, create a zone with offset 20 and length 7 and speed value of 1.5 )\n")
	
	func test_pop_question_from_queue():
		var event_name = Globals.questions['nodes'][0].keys()[0]
		terminal_content_node.handle_event_from_action_event(Globals.questions['nodes'][0].keys()[0], Globals.questions['nodes'][0][event_name])
		assert_eq(int(terminal_content_node.pop_selected_question(1).id), 1)

