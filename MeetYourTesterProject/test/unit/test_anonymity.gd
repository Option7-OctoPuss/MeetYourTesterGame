extends GutTest

class TestAnonymity:
	extends GutTest 
	
	var anonymity_node_name = "AnonymityBarControl"
	var game_scene = null

	func before_all():
		gut.p('TestTerminalContent:  pre-run')
		var file = FileAccess.get_file_as_string(Globals.questions_test_file_path)
		Globals.questions = JSON.parse_string(file)

	func before_each():
		game_scene = preload("res://ui/main_screen/main_game_scene.tscn").instantiate()
		Globals.current_anonymity_value = 0

	func after_each():
		game_scene.free()

	func test_single_anonymity_answer():
		var anon_node = game_scene.find_child(anonymity_node_name)
		var custom_param = {
			"type": "anon_bar", 
			"effects": {
				"value": 7, 
				"zone": {
					"offset" : 20, 
					"speedValue": 1.5, 
					"length": 7
				}
			}                 
		}
		
		assert_not_null(anon_node)
		
		anon_node.handle_answer_signal(custom_param)
		
		assert_eq(Globals.current_anonymity_value, 7)

	func test_double_answer():
		var anon_node = game_scene.find_child(anonymity_node_name)
		var custom_param = {
			"type": "anon_bar", 
			"effects": {
				"value": 7, 
				"zone": {
					"offset" : 20, 
					"speedValue": 1.5, 
					"length": 7
				}
			}                 
		}
				
		assert_not_null(anon_node)
		
		anon_node.handle_answer_signal(custom_param)
		
		custom_param = {
			"type": "anon_bar", 
			"effects": {
				"value": 8, 
				"zone": {
					"offset" : 20, 
					"speedValue": 1.5, 
					"length": 7
				}
			}                 
		}
		
		anon_node.handle_answer_signal(custom_param)		
	
		assert_eq(Globals.current_anonymity_value, 15)
		
	func test_type_progress_bar():
		var anon_node = game_scene.find_child(anonymity_node_name)
		var custom_param = {
			"type": "progress_bar", 
			"effects": {
				"value": 5, 
				"zone": {
					"offset" : 20, 
					"speedValue": 1.5, 
					"length": 7
				}
			}                 
		}
		
		assert_not_null(anon_node)
		
		anon_node.handle_answer_signal(custom_param)
		
		assert_eq(Globals.current_anonymity_value, 0)
