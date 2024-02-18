extends GutTest

class TestAnonymity:
	extends GutTest 
	
	var anonymity_node_name = "AnonymityBarControl"
	var main_game_scene = null
	var terminal_scene = null
	var anon_node = null
	var test_event_name = "GutTest"
	
	func before_all():
		gut.p('TestTerminalContent:  pre-run')

	func before_each():
		main_game_scene = preload("res://ui/main_screen/main_game_scene.tscn").instantiate()
		terminal_scene = preload("res://ui/main_screen/terminal/terminal_mock.tscn").instantiate()
		add_child(main_game_scene)
		anon_node = main_game_scene.find_child(anonymity_node_name)
		assert_not_null(anon_node)

	func after_each():
		main_game_scene.free()
		terminal_scene.free()

	func test_answer_updates_anonymity():
		var test_answers = Globals.questions[test_event_name][0].answers
		var test_selected_answer = test_answers[2]
		var previous_anon_value = Globals.current_anonymity_value
		anon_node.handle_answer_signal(test_selected_answer)
		assert_eq(Globals.current_anonymity_value, previous_anon_value + test_selected_answer[Globals.ANONYMITY_BAR_DICTIONARY_KEY].value)

	func test_answer_doesnt_update_anonymity():
		var test_answers = Globals.questions[test_event_name][0].answers
		var test_selected_answer = test_answers[1]
		var previous_anon_value = Globals.current_anonymity_value
		anon_node.handle_answer_signal(test_selected_answer)
		assert_eq(Globals.current_anonymity_value, previous_anon_value)
