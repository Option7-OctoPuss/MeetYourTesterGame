extends GutTest
class TestDeadlinePO:
	extends GutTest
	var scene_instance = null
	var main_game_scene = null
	var main_game_scene_load = null
	var deadline_scene = null
	var deadline_scene_load = null
	var progress_bar_control = null
	var progress_bar_scene = null
	var progress_bar_scene_load = null
	var terminal_scene_load = null
	
	func before_all():
		gut.p('TestDeadlinePO:  pre-run')
		var file = FileAccess.get_file_as_string(Globals.deadlines_file_path)
		if file:
			var parse_json_file = JSON.parse_string(file)
			Globals.deadlines = parse_json_file["difficulty-1"]
		else:
			gut.p("File not found")
	
	func before_each():
		gut.p('TestDeadlinePO:  setup')
		main_game_scene_load = preload ("res://ui/main_screen/main_game_scene.tscn")
		progress_bar_scene_load = preload ("res://ui/main_screen/progress_bar/progress_bar.tscn")
		deadline_scene_load = preload ("res://ui/main_screen/progress_bar/progress_bar_deadline_scene.tscn")
		terminal_scene_load = preload ("res://ui/main_screen/terminal/terminal_mock.tscn")
		main_game_scene = main_game_scene_load.instantiate()
		progress_bar_scene = progress_bar_scene_load.instantiate()
		deadline_scene = deadline_scene_load.instantiate()
		terminal_scene_load = terminal_scene_load.instantiate()
		# add_child_autofree(main_game_scene)
		add_child(main_game_scene)
		main_game_scene.add_child(progress_bar_scene)
		main_game_scene.add_child(terminal_scene_load)
		
		# add_child_autofree(progress_bar_scene)
		# add_child(deadline_scene)
		# main_game_scene = double(main_game_scene_load).instantiate()
		# progress_bar_scene = double(progress_bar_scene_load).instantiate()
		# deadline_scene = double(deadline_scene_load).instantiate()
		# progress_bar_control = main_game_scene.get_node("ProgressBar")
		# deadline_scene = preload ("res://ui/main_screen/progress_bar/progress_bar_deadline_scene.tscn").instantiate()
		# add_child(main_game_scene)
		# add_child(progress_bar_scene)
		# call_deferred("add_child", main_game_scene)
		# call_deferred("add_child", progress_bar_scene)
		
	func after_each():
		gut.p('TestDeadlinePO:  teardown')
		assert_no_new_orphans('Orphans detected after teardown')
		main_game_scene.free()
		# progress_bar_scene.free()
		# deadline_scene.free()
		
	func after_all():
		print("TestDeadlinePO:  DONE")
		gut.p('TestDeadlinePO:  post-run')

	func test_first_deadline_pending():
		gut.p("Testing if the deadline is pending")
		print("Testing test_first_deadline_pending")
		progress_bar_scene.instantiate_scene()
		var deadlines_container = progress_bar_scene.get_node("DeadlinesContainer")
		# #! PASS THE PROGRESS BAR NODE HERE SO IT CAN BE USED IN THE FUNCTION
		progress_bar_scene.decrease_deadlines_timers()
		var deadline = deadlines_container.get_child(0).get_node("Deadline")
		print(deadline.texture.resource_path)
		assert_string_contains(deadline.texture.resource_path, "pending")

	func test_first_deadline_pending_non_zero_progress_bar_and_timer():
		gut.p("Testing if the deadline is pendind with non zero progress bar and timer")
		print("Testing test_first_deadline_pending_non_zero_progress_bar_and_timer")
		progress_bar_scene.instantiate_scene()
		var deadlines_container = progress_bar_scene.get_node("DeadlinesContainer")
		var progress_frame = progress_bar_scene.get_node("ProgressFrame")
		print("Progress frame children", progress_frame.get_child_count())
		var game_progress_bar = progress_frame.get_node("GameProgressBar")
		print("Is progress bar valid: ", game_progress_bar)
		# progress_frame.add_child(game_progress_bar)
		# progress_bar_scene.add_child(progress_frame)
		Globals.gameTime = 10
		print("Globals.gameTime")
		# var game_progress_bar = progress_bar_scene.get_node("ProgressFrame").get_node("GameProgressBar")
		game_progress_bar.value = 10
		print("game_progress_bar.value")
		progress_bar_scene.decrease_deadlines_timers()
		print("decrease_deadlines_timers")
		assert_string_contains(deadlines_container.get_child(0).get_node("Deadline").texture.resource_path, "pending")
		print("assert_string_contains")

	func test_first_deadline_reached():
		gut.p("Testing if the deadline is reached by moving the value of the progress bar")
		print("Testing test_first_deadline_reached")
		progress_bar_scene.instantiate_scene()
		var deadlines_container = progress_bar_scene.get_node("DeadlinesContainer")

		progress_bar_scene.get_node("ProgressFrame/GameProgressBar").value = 60
		progress_bar_scene.decrease_deadlines_timers()
		assert_string_contains(deadlines_container.get_child(0).get_node("Deadline").texture.resource_path, "reached")

	func test_first_deadline_missed():
		print("Testing test_first_deadline_missed")
		gut.p("Testing if the deadline is missed by changing the timer and current progress bar value is less than the position of deadline")
		progress_bar_scene.instantiate_scene()
		var deadlines_container = progress_bar_scene.get_node("DeadlinesContainer")
		Globals.gameTime = 130
		progress_bar_scene.get_node("ProgressFrame/GameProgressBar").value = 10
		progress_bar_scene.decrease_deadlines_timers()
		assert_string_contains(deadlines_container.get_child(0).get_node("Deadline").texture.resource_path, "missed")
