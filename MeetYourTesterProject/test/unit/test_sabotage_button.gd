extends GutTest

class TestSabotageButton:
	extends GutTest
	var scene_instance = null
	var main_game_scene = null
	var deadline_scene = null
	var progress_bar_control = null
	var sabotage_node = null
	func before_all():
		gut.p('TestSabotageButton:  pre-run')
	
	func before_each():
		gut.p('TestSabotageButton:  setup')
		main_game_scene = preload ("res://ui/main_screen/main_game_scene.tscn").instantiate()
		add_child_autofree(main_game_scene)
		progress_bar_control = main_game_scene.get_node("ProgressBarControl")
		sabotage_node = main_game_scene.get_node("SabotageButtonControl")

	func after_each():
		gut.p('TestSabotageButton:  teardown')
		
	func after_all():
		gut.p('TestSabotageButton:  post-run')

	func test_add_charge():
		gut.p("Testing charge is added")
		sabotage_node.charge_count = 0
		sabotage_node.increase_charge_count()
		assert_eq(sabotage_node.charge_count, 1, "Charge count should be 1")
	
	func test_limit_2_charges():
		gut.p("Testing charge is limited to 2")
		sabotage_node.charge_count = 2
		sabotage_node.increase_charge_count()
		assert_eq(sabotage_node.charge_count, 2, "Charge count should be 2")

	func test_decrease_charge():
		gut.p("Testing charge is decreased")
		sabotage_node.charge_count = 1
		sabotage_node.decrease_charge_count()
		assert_eq(sabotage_node.charge_count, 0, "Charge count should be 0")
