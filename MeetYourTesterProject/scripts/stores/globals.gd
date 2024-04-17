extends Node

var DEBUG_MODE = true

var gamePaused = false
var gameSpeed = 1
var gameTime= 0
var isPausable = true

var current_difficulty_level

var deadlines_file_path = "res://deadlines/Deadlines.json"
var deadlines:Array = []

var questions_dir_path = "res://questions"
var questions_file_path = "res://questions/example_question.json"
var messages_file_path = "res://messages/end_game.json"
var questions_test_file_path = "res://questions/example_question_test.json"
var questions:Dictionary = {}

var terminalHistory = "";
var currentAnswer:Dictionary = {}

var current_anonymity_value = 100 
var anonymity_value_alert_threshold = 4
var max_anonimity_value = 100 # starting value
var max_pause_time = 1

var menuOpen = false

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
const ANON_VALUE_SABOTAGE_TRIGGER = 50
const SABOTAGE_ANON_DECREASE_VALUE = 20
var DECREASE_FINAL_DEADLINE_AMOUNT = 10 # in seconds

var end_game_reason = null

var bg_music_volume = 0
var sound_fx_volume = 0

var start_tutorial = "main"
