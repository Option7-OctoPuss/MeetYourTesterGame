extends Node

var DEBUG_MODE = true

var gamePaused = false
var gameSpeed = 1
var gameTime= 0

var questions_dir_path = "res://questions"
var questions_file_path = "res://questions/example_question.json"
var questions_test_file_path = "res://questions/example_question_test.json"
var questions:Dictionary = {}

var terminalHistory = "";
var currentAnswer:Dictionary = {}

var current_anonymity_value = 0
var anonymity_value_alert_threshold = 4
enum progress_bar_zone_length {
	SMALL=1,
	MEDIUM=2,
	LARGE=3,
}
var progress_bar_possible_speeds = [0.3,0.6,1] # a value is chosen based on selected difficulty
var progress_bar_speed = progress_bar_possible_speeds[0]

var randomTimerForActionEventInactivity = 10 # 75
var randomTimerForActionEventAcceptance = 10

const ANONYMITY_BAR_DICTIONARY_KEY = "anon_bar"
