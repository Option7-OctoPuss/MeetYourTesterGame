extends GutTest
class TestReturnToMenuFromGameScenePO:
	extends GutTest
	var main_game_scene = null
	var return_to_main_menu_popup = null
	
	func before_all():
		gut.p('TestReturnToMenuFromGameScenePO:  pre-run')

	func before_each():
		gut.p('TestReturnToMenuFromGameScenePO:  setup')
		main_game_scene = preload("res://ui/main_screen/main_game_scene.tscn").instantiate()
		return_to_main_menu_popup = preload("res://ui/menus/return_to_main_menu.tscn").instantiate()
		main_game_scene._ready()
		return_to_main_menu_popup._ready()
		
	func after_each():
		gut.p('TestReturnToMenuFromGameScenePO:  teardown')
		main_game_scene.free()
		
	func after_all():
		gut.p('TestReturnToMenuFromGameScenePO:  post-run')

	func test_popup_after_press_quit_button():
		gut.p("Testing if the return to main menu pop-up is visible after the user press the quit button")
		main_game_scene.back_to_main_menu()
		assert_true(main_game_scene.get_node("ReturnToMainMenu").get_child(0).visible)		
