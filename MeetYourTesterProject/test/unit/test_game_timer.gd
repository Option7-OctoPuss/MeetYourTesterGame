extends GutTest

class TestGameTimerPO:
	extends GutTest 
	
	var timer_node_node_name = "TimerNode"
	var play_pause_btn = "PlayPauseBtn"
	var speed_up_btn = "SpeedUpBtn"
	var game_scene = null
	var timer_node = null

	func before_all():
		gut.p('TestGameTimerPO:  pre-run')

	func before_each():
		game_scene = preload("res://ui/main_screen/main_game_scene.tscn").instantiate()
		timer_node = game_scene.find_child(timer_node_node_name)

	func after_each():
		game_scene.free()
		
	func test_game_pause(params=use_parameters([[false, true], [true, false]])):
		Globals.gamePaused = params[0]
		game_scene.find_child(play_pause_btn)._on_button_pressed()
		var expected_value = params[1]
		assert_eq(timer_node.paused, expected_value, "Property 'paused' of timer node should be " + str(expected_value) + ": " + str(timer_node.paused))

	func test_timer_speed_game(params=use_parameters([[3, str(1)], [1, str(0.5)], [2, str(0.333)]])):
		Globals.gameSpeed = params[0]
		game_scene.find_child(speed_up_btn)._on_button_pressed()
		var actual_wait_time = str(timer_node.wait_time).substr(0, 5)
		var expected_wait_time = params[1]
		assert_eq(actual_wait_time, expected_wait_time, "With game speed of : " + str(Globals.gameSpeed) + " property 'wait_time' of timer node should be " + expected_wait_time + ": " + actual_wait_time)

	func test_timer_string_format():
		var timer_script = load("res://ui/main_screen/timer.gd").new()
		var timer_formatted = timer_script.float_to_time(float(42))
		assert_eq(timer_formatted, "00:42", "With 42 seconds of game playthrough the formatted time should be 00:42: " + timer_formatted)
		timer_script.free()
