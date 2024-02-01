extends GutTest

class TestProgressBar:
	extends GutTest 
	
	var progress_bar_control_node_name = "ProgressBarControl"
	var progress_bar_node_name = "GameProgressBar"
	var terminal_content_node_name = "terminal_content"
	var game_scene = null
	var terminal_scene = null
	var progress_bar_node = null
	var terminal_content_node = null
	var event_name = null

	func before_all():
		gut.p('TestProgressBar:  pre-run')
		var file = FileAccess.get_file_as_string(Globals.questions_test_file_path)
		Globals.questions = JSON.parse_string(file)
		event_name = Globals.questions['nodes'].keys()[0]

	func before_each():
		game_scene = preload("res://ui/main_screen/main_game_scene.tscn").instantiate()
		terminal_scene = preload("res://ui/main_screen/terminal/terminal_mock.tscn").instantiate()
		progress_bar_node = game_scene.find_child(progress_bar_control_node_name)
		terminal_content_node = terminal_scene.find_child(terminal_content_node_name)

	func after_each():
		game_scene.free()
		terminal_scene.free()

	func test_progress_bar_effect():
		# TODO: we should be able to instantiate all the terminal and progress bar nodes without calling directly the methods
		terminal_content_node.handle_event_from_action_event(Globals.questions['nodes'].keys()[0], Globals.questions['nodes'][event_name])
		terminal_content_node.handle_meta_clicked("1_1") # questionId_answerId of 'example_question_test.json' file       
		var target_answer = Globals.questions['nodes'][event_name].questions[0].answers[1].target
		progress_bar_node.apply_progress_bar_effects(target_answer)
		assert_eq(progress_bar_node.find_child(progress_bar_node_name).value, target_answer.effects.value)

