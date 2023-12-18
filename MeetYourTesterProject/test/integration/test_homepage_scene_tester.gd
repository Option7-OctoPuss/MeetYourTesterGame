extends GutTest
class homePageTestPO:
	extends GutTest
	var scene_instance = null
	var home_scene = null
	var home_btns_node_name = "GridContainer"
	
	func before_all():
		gut.p('TestHomeScenePO:  pre-run')
	
	func before_each():
		gut.p('TestHomeScenePO:  setup')
		home_scene = preload("res://ui/menus/main_menu.tscn").instantiate()
		
	func after_each():
		gut.p('TestHomeScenePO:  teardown')
		
	func after_all():
		gut.p('TestHomeScenePO:  post-run')	

	func homepage_scene_tester_initialization():
		assert_not_null(home_scene, "Scene instance should be initialized")

	func test_home_btns_count():
		gut.p("Testing if the buttons are initialized and have correct names")
		var home_btns = home_scene.find_child(home_btns_node_name)
		if home_btns == null:
			gut.p("HomeButtons is null")
		var child_count = home_btns.get_child_count()
		var child_names= ["StartIcon", "CenterStartLabel", "TutorialIcon", "CenterTutorialLabel","OptionsIcon", "CenterOptionsLabel", "QuitIcon", "CenterQuitLabel"]
		if child_count < 8:
			var fmt_str = "{name} has {children}".format({"name": home_btns.get_name(), "children": child_count})
			gut.p(fmt_str)
			for child in child_count:
				gut.p(home_btns.get_child(child).get_name())
		assert_not_null(home_btns, "HomeButtons should be initialized")
		assert_eq(home_btns.get_child_count(), 4, "HomeButtons should have 3 children and not {count}".format({"count": child_count}))
		for i in range(child_count):
			assert_eq(home_btns.get_child(i).get_name(), child_names[i], "Child {i} should be {name}".format({"i": i, "name": child_names[i]}))

	func test_home_button_start_game():
		gut.p("Testing if the buttons have correct difficulty values")
		var home_btns = home_scene.find_child(home_btns_node_name)
		var child_count = home_btns.get_child_count()
		var test_scene_path = "res://test/test_scene.tscn"
		var main_scene_path = "res://ui/main_screen/main_game_scene.tscn"
		var home_btn_instance = home_btns.get_child(0)
		var scene1 = get_tree().current_scene
		home_btn_instance._on_Button_pressed()
		var scene2 = get_tree().current_scene
		assert_not_same(scene1, scene2)
		if (scene1 != scene2):
			gut.p("Scene successfully changed")
		else:
			gut.p("Scene not changed")
