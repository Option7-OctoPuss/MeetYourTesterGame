# https://github.com/bitwes/Gut/wiki/Asserts-and-Methods
# https://github.com/bitwes/Gut/blob/master/test/samples/test_readme_examples.gd
# Author: Alessandro Oneto & Husam Jenidi
# :>
extends GutTest
class TestActionEventPO:
	extends GutTest
	var main_game_scene = null
	var terminal_scene = null
	var action_event_btn_name = "Business_Logic"
	var terminal_name = "_terminal_mock"
	var terminal_content_node_name = "terminal_content"
	var action_event_btn:TextureButton
	var test_event_name = 'GutTest'
	var terminal_content_node:RichTextLabel
	
	func before_all():
		gut.p('TestActionEventPO:  pre-run')
	
	func before_each():
		gut.p('TestActionEventPO:  setup')
		main_game_scene = preload("res://ui/main_screen/main_game_scene.tscn").instantiate()
		terminal_scene = preload("res://ui/main_screen/terminal/terminal_mock.tscn").instantiate()
		add_child(main_game_scene)
		terminal_content_node = terminal_scene.find_child(terminal_content_node_name)
		action_event_btn = main_game_scene.find_child(action_event_btn_name)
		assert_not_null(action_event_btn, "Action Event button should be found")
	
	func after_each():
		gut.p('TestActionEventPO:  teardown')
		main_game_scene.free()
		terminal_scene.free()

	func after_all():
		gut.p('TestActionEventPO:  post-run')
		
	func test_main_game_scene_initialization():
		assert_not_null(main_game_scene, "Scene instance should be initialized")
	
	func test_click_on_action_event_disables_it():
		gut.p("Testing if clicking on the action event changes its state correctly")
		action_event_btn._pressed()
		assert_true(action_event_btn.disabled, "After clicking, button should be disabled")
	
	func test_click_on_action_event_updates_terminal():
		gut.p("Testing if clicking on the action event updates the text on the terminal")
		action_event_btn._pressed()
		terminal_scene.handle_event_from_action_event({"node_name":test_event_name})
		assert_string_contains(terminal_content_node.text, test_event_name)
		
	# TODO enable test when code from other branch changes the texture back 
	#func test_click_on_mockup_answer_changes_action_event_texture():
		#gut.p("Testing if clicking on the mockup answer button disables the action event and changes its texture")
		#action_event_btn._pressed()
		#var texture_while_answering:Image = action_event_btn.texture_disabled.get_image()
		##answer_mockup = main_game_scene.find_child("Terminal").find_child(answer_mockup_name)
		##assert_true(answer_mockup.visible,"Answer mockup button should be visible")
		##assert_false(answer_mockup.disabled,"Answer mockup button should be enabled")
		##answer_mockup._pressed()
		#var texture_after_answer:Image = action_event_btn.texture_disabled.get_image()
		#var terminal_content_node = main_game_scene.find_child("Terminal").find_child(terminal_content_name)
		#terminal_content_node.handle_event_from_action_event(action_event_btn_name, Globals.questions['nodes'][action_event_btn_name])
		#var question_id = 3
		#var question_from_queue = terminal_content_node.pop_selected_question(question_id)
		#var answer_idx = 0
		#terminal_content_node.update_terminal_content(question_from_queue, answer_idx)
		#assert_ne(texture_while_answering,texture_after_answer,"Action Event button should change texture")
