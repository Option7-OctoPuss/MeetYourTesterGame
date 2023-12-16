# https://github.com/bitwes/Gut/wiki/Asserts-and-Methods
# https://github.com/bitwes/Gut/blob/master/test/samples/test_readme_examples.gd
# Author: Szymon Zinkoiwcz
# :>
extends GutTest
class TestDiffScenePO:
	extends GutTest
	var scene_instance = null
	var diff_scene = null
	var diff_btns_node_name = "DiffBtns"
	func before_all():
		gut.p('TestDiffScenePO:  pre-run')

	func before_each():
		gut.p('TestDiffScenePO:  setup')
		diff_scene = preload("res://ui/menus/difficulty/diff_scene.tscn").instantiate()
	func after_each():
		gut.p('TestDiffScenePO:  teardown')

	func after_all():
		gut.p('TestDiffScenePO:  post-run')
		
	func test_diff_scene_initialization():
		assert_not_null(diff_scene, "Scene instance should be initialized")
	
	func test_diff_btns_count():
		gut.p("Testing if the buttons are initialized and have correct names")
		var diff_btns = diff_scene.find_child(diff_btns_node_name)
		if diff_btns == null:
			gut.p("DiffButtons is null")
		var child_count = diff_btns.get_child_count()
		var child_names= ["EasyDiffBtn", "MediumDiffBtn", "HardDiffBtn", "CancelBtn"]
		if child_count < 4:
			var fmt_str = "{name} has {children}".format({"name": diff_btns.get_name(), "children": child_count})
			gut.p(fmt_str)
			for child in child_count:
				gut.p(diff_btns.get_child(child).get_name())
		# TODO this should check for individiual nodes init
		assert_not_null(diff_btns, "DiffButtons should be initialized")
		assert_eq(diff_btns.get_child_count(), 4, "DiffButtons should have 3 children and not {count}".format({"count": child_count}))
		for i in range(child_count):
			assert_eq(diff_btns.get_child(i).get_name(), child_names[i], "Child {i} should be {name}".format({"i": i, "name": child_names[i]}))
	
	func test_diff_btns_difficulties():
		gut.p("Testing if the buttons have correct difficulty values")
		var diff_btns = diff_scene.find_child(diff_btns_node_name)
		var child_count = diff_btns.get_child_count()
		var global_diff = DiffStore.player_difficulty
		var test_scene_path = "res://test/test_scene.tscn"
		var main_scene_path = "res://ui/main_screen/main_game_scene.tscn"
		gut.p("Global difficulty is {diff}".format({"diff": global_diff}), 2)
		for i in range(child_count):
			var diff_btn_instance = diff_btns.get_child(i)
			var diff_btn_instance_level = diff_btn_instance.difficulty_level
			gut.p("Difficulty of a node {node} is {diff}".format({"node": diff_btns.get_child(i).get_name(), "diff": diff_btn_instance_level}), 2)
			diff_btn_instance._on_Button_pressed()
			gut.p("Global difficulty is set to {diff} now".format({"diff": DiffStore.player_difficulty}), 2)
			assert_eq(DiffStore.player_difficulty, diff_btn_instance_level, "Global difficulty should be {diff}".format({"diff": diff_btn_instance_level}))
			# TODO Check if the scene is changed
			if i == child_count :
				# Not change scene, but instanciate it instead
				SceneManager.change_scene(test_scene_path)
				assert_same(SceneManager.current_scene_path, test_scene_path, "Scene should be changed to {scene}".format({"scene": test_scene_path}))
				gut.p("Scene should be changed to {scene}".format({"scene": get_tree().current_scene.name}), 0)
			else:
				SceneManager.go_back()
				assert_same(SceneManager.current_scene_path, main_scene_path, "Scene should be changed to {scene}".format({"scene": main_scene_path}))