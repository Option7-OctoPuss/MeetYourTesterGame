extends GutTest

class TestProgressBar:
	extends GutTest 
	
	var progress_bar_control_node_name = "ProgressBarControl"
	var progress_bar_texture_node_name = "GameProgressBar"
	var terminal_content_node_name = "terminal_content"
	var game_scene = null
	var terminal_scene = null
	var progress_bar_control_node = null
	var progress_bar_texture_node = null
	var terminal_content_node = null
	var test_event_name = 'GutTest'
	var test_questions = null
	var test_question_id = null

	func before_all():
		gut.p('TestProgressBar:  pre-run')

	func before_each():
		game_scene = preload("res://ui/main_screen/main_game_scene.tscn").instantiate()
		terminal_scene = preload("res://ui/main_screen/terminal/terminal_mock.tscn").instantiate()
		add_child(game_scene)
		progress_bar_control_node = game_scene.find_child(progress_bar_control_node_name)
		progress_bar_texture_node = progress_bar_control_node.find_child(progress_bar_texture_node_name)
		terminal_content_node = terminal_scene.find_child(terminal_content_node_name)
		test_questions = Globals.questions[test_event_name] # if more than 1 in the array, it will break
		test_question_id = test_questions[0].id

	func after_each():
		game_scene.free()
		terminal_scene.free()

	func generate_and_select_answer(test_selected_answer_idx: int, test_selected_answer: Dictionary):
		terminal_content_node.handle_event_from_action_event(test_event_name, test_questions)
		terminal_content_node.handle_meta_clicked("%s_%d" % [test_question_id, test_selected_answer_idx]) # questionId_answerId of 'example_question_test.json' file       
		progress_bar_control_node.apply_progress_bar_effects(test_selected_answer)

	func test_answer_updates_value():
		var test_selected_answer_idx = 0
		var test_selected_answer = test_questions[0].answers[test_selected_answer_idx]
		generate_and_select_answer(test_selected_answer_idx, test_selected_answer)
		assert_eq(progress_bar_texture_node.value, test_selected_answer.progress_bar.value) 

	func test_answer_creates_zone():
		var test_selected_answer_idx = 1
		var test_selected_answer = test_questions[0].answers[test_selected_answer_idx]
		generate_and_select_answer(test_selected_answer_idx, test_selected_answer)
		assert_true(progress_bar_control_node.is_zone_present()) 
		
	# check that the bar auto increments by a positive value
	func test_progress_bar_auto_increment():
		var progress_before = progress_bar_texture_node.value
		await get_tree().create_timer(1).timeout # sleep to wait for auto_increment
		var progress_after = progress_bar_texture_node.value
		assert_gt(progress_after, progress_before)
		
	# check that the bar cannot go over the max value
	func test_progress_bar_reaches_max():
		progress_bar_texture_node.value = progress_bar_texture_node.max_value + 1
		assert_eq(progress_bar_texture_node.value, progress_bar_texture_node.max_value)
