extends GutTest
class TestExitGameFromGameScenePO:
	extends GutTest
	var main_game_scene = null
	
	func before_all():
		gut.p('TestExitGameFromGameScenePO:  pre-run')

	func before_each():
		gut.p('TestExitGameFromGameScenePO:  setup')
		main_game_scene = preload("res://ui/main_screen/main_game_scene.tscn").instantiate()
		main_game_scene._ready()
		
	func after_each():
		gut.p('TestExitGameFromGameScenePO:  teardown')
		main_game_scene.free()
		
	func after_all():
		gut.p('TestExitGameFromGameScenePO:  post-run')

	func test_popup_after_press_quit_button():
		gut.p("Testing if the exit game pop-up is visible after the user press the quit button")
		#Input.action_press("show_prompt")
		#main_game_scene._process(0)
		#Input.action_release("show_prompt")
		#await get_tree().create_timer(1).timeout
		main_game_scene.handle_quit()
		assert_true(main_game_scene.get_node("ExitPrompt").get_child(0).visible)
		
