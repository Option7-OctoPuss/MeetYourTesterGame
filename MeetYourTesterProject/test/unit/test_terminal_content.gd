extends GutTest

class TestTerminalContent:
	extends GutTest 
	
	var terminal_content_node_name = "terminal_content"
	var play_pause_btn = "PlayPauseBtn"
	var speed_up_btn = "SpeedUpBtn"
	var main_game_scene = null
	var terminal_scene = null
	var terminal_content_node = null
	var test_event_name = "GutTest"
	var test_questions = null
	var test_question = null
	var test_question_id = null
	
	func before_all():
		gut.p('TestTerminalContent:  pre-run')

	func before_each():
		main_game_scene = preload("res://ui/main_screen/main_game_scene.tscn").instantiate()
		terminal_scene = preload("res://ui/main_screen/terminal/terminal_mock.tscn").instantiate()
		add_child(main_game_scene)
		terminal_content_node = terminal_scene.find_child(terminal_content_node_name)
		test_questions = Globals.questions[test_event_name] # if more than 1 in the array, it will break
		test_question = test_questions[0]
		test_question_id = test_question.id
		
	func after_each():
		main_game_scene.free()
		terminal_scene.free()

	func test_retrieve_question():
		var current_question = terminal_content_node.retrieve_question(test_questions)
		assert_eq(current_question.id, test_question.id)
		assert_eq(current_question.title, test_question.title)
	
	func test_retrieve_question_answer():
		var current_question = terminal_content_node.retrieve_question(test_questions)
		assert_eq(current_question.answers.size(), test_question.answers.size())
		assert_eq(current_question.answers[0].text, test_question.answers[0].text)
	
	func test_terminal_content_contains_question():
		terminal_content_node.handle_event_from_action_event(test_event_name, test_questions)
		assert_gt(terminal_content_node.get_total_character_count(), 0)
		assert_string_contains(terminal_content_node.text, test_event_name)
		
	func test_pop_question_from_queue():
		terminal_content_node.handle_event_from_action_event(test_event_name, test_questions)
		assert_eq(terminal_content_node.pop_selected_question(test_question_id)[1].id, test_question_id)
