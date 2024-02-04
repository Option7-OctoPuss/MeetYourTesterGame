extends GutTest

class TestTerminalContent:
	extends GutTest 
	
	var terminal_content_node_name = "terminal_content"
	var play_pause_btn = "PlayPauseBtn"
	var speed_up_btn = "SpeedUpBtn"
	var game_scene = null
	var main_game_scene = null
	var terminal_content_node = null
	var event_name = null

	func before_all():
		gut.p('TestTerminalContent:  pre-run')
		var file = FileAccess.get_file_as_string(Globals.questions_test_file_path)
		Globals.questions = JSON.parse_string(file)
		event_name = Globals.questions['nodes'].keys()[0]

	func before_each():
		#game_scene = preload("res://ui/main_screen/terminal/terminal_mock.tscn").instantiate()
		main_game_scene = preload("res://ui/main_screen/main_game_scene.tscn").instantiate()
		terminal_content_node = main_game_scene.find_child("Terminal").find_child("_terminal_mock").find_child(terminal_content_node_name)

	func after_each():
		main_game_scene.free()

	func test_backend_node_id():
		var current_question = terminal_content_node.retrieve_question(Globals.questions['nodes'][event_name])
		var question_id = 1
		assert_eq(int(current_question.id), question_id)

	func test_backend_node_single_answer_count():
		var current_question = terminal_content_node.retrieve_question(Globals.questions['nodes'][event_name])
		assert_eq(current_question.answers.size(), 1)

	func test_backend_node_single_answer_text():
		var current_question = terminal_content_node.retrieve_question(Globals.questions['nodes'][event_name])
		assert_eq(current_question.answers[0].text, "First answer, progress bar effect value (weight) 1, create a zone with offset 20 and length 7 and speed value of 1.5 )")
	
	func test_not_empty_terminal_content():
		terminal_content_node.handle_event_from_action_event(Globals.questions['nodes'].keys()[0], Globals.questions['nodes'][event_name])
		var question_id = 1
		var question_from_queue = terminal_content_node.pop_selected_question(question_id)
		var answer_idx = 0
		terminal_content_node.update_terminal_content(question_from_queue, answer_idx)
		assert_ne(terminal_content_node.get_text(), "")
		
	func test_terminal_contains_specific_content():
		terminal_content_node.handle_event_from_action_event(Globals.questions['nodes'].keys()[0], Globals.questions['nodes'][event_name])
		var question_id = 1
		var question_from_queue = terminal_content_node.pop_selected_question(question_id)
		var answer_idx = 0
		terminal_content_node.update_terminal_content(question_from_queue, answer_idx)
		assert_string_contains(terminal_content_node.get_text(), "First answer, progress bar effect value (weight) 1, create a zone with offset 20 and length 7 and speed value of 1.5")
	
	func test_pop_question_from_queue():
		terminal_content_node.handle_event_from_action_event(Globals.questions['nodes'].keys()[0], Globals.questions['nodes'][event_name])
		var question_id = 1
		assert_eq(int(terminal_content_node.pop_selected_question(question_id).id), question_id)

	func test_emit_answer_signal():
		terminal_content_node.handle_event_from_action_event(Globals.questions['nodes'].keys()[0], Globals.questions['nodes'][event_name])
		terminal_content_node.handle_meta_clicked("1_0") # questionId_answerId of 'example_question_test.json' file
		var target_answer = Globals.questions['nodes'][event_name].questions[0].answers[0].target
		assert_same(target_answer,Globals.currentAnswer)

