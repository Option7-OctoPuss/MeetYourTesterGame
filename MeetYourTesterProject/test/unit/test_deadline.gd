extends GutTest
class TestDeadlinePO:
	extends GutTest
	var scene_instance = null
	var main_game_scene = null
	var deadline_scene = null
	var progress_bar_control = null
	
	func before_all():
		gut.p('TestDeadlinePO:  pre-run')
		var file = FileAccess.get_file_as_string(Globals.deadlines_file_path)
		if file:
			var parse_json_file = JSON.parse_string(file)
			Globals.deadlines = parse_json_file["difficulty-1"]
	
	func before_each():
		gut.p('TestDeadlinePO:  setup')
		main_game_scene = preload("res://ui/main_screen/main_game_scene.tscn").instantiate()
		progress_bar_control = main_game_scene.get_node("ProgressBarControl")
		deadline_scene = preload("res://ui/main_screen/progress_bar_deadline_scene.tscn").instantiate()
		
	func after_each():
		gut.p('TestDeadlinePO:  teardown')
		main_game_scene.free()
		deadline_scene.free()
		
	func after_all():
		gut.p('TestDeadlinePO:  post-run')

	func test_first_deadline_pending():
		gut.p("Testing if the deadline is pendind")
		var deadlines_container = progress_bar_control.get_node("DeadlinesContainer")
		progress_bar_control.create_deadlines()
		progress_bar_control.decrease_deadlines_timers()
		assert_string_contains(deadlines_container.get_child(0).get_node("Deadline").texture.resource_path, "pending")

	func test_first_deadline_pending_non_zero_progress_bar_and_timer():
		gut.p("Testing if the deadline is pendind with non zero progress bar and timer")
		var deadlines_container = progress_bar_control.get_node("DeadlinesContainer")
		progress_bar_control.create_deadlines()
		Globals.gameTime = 10
		progress_bar_control.get_node("GameProgressBar").value = 10
		progress_bar_control.decrease_deadlines_timers()
		assert_string_contains(deadlines_container.get_child(0).get_node("Deadline").texture.resource_path, "pending")

	func test_first_deadline_reached():
		gut.p("Testing if the deadline is reached by moving the value of the progress bar")
		var deadlines_container = progress_bar_control.get_node("DeadlinesContainer")
		progress_bar_control.create_deadlines()
		progress_bar_control.get_node("GameProgressBar").value = 60
		progress_bar_control.decrease_deadlines_timers()
		assert_string_contains(deadlines_container.get_child(0).get_node("Deadline").texture.resource_path, "reached")

	func test_first_deadline_missed():
		gut.p("Testing if the deadline is missed by changing the timer and current progress bar value is less than the position of deadline")
		var deadlines_container = progress_bar_control.get_node("DeadlinesContainer")
		progress_bar_control.create_deadlines()
		progress_bar_control.get_node("GameProgressBar").value = 10
		deadlines_container.get_child(0).find_child("DeadlineTimer").text = "00:01"
		progress_bar_control.decrease_deadlines_timers()
		assert_string_contains(deadlines_container.get_child(0).get_node("Deadline").texture.resource_path, "missed")
