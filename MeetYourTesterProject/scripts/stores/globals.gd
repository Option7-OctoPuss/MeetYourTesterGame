extends Node

var DEBUG_MODE = true

var gamePaused = false
var gameSpeed = 1
var gameTime= 0

var questions_file_path = "res://questions/example_question.json"
var questions_test_file_path = "res://questions/example_question_test.json"
var questions:Dictionary = {}

var terminalHistory = "";
var currentAnswer:Dictionary = {}

var current_anonymity_value = 0
var anonymity_value_alert_threshold = 4
var progress_bar_zone_small = 1
var progress_bar_zone_medium = 2
var progress_bar_zone_large = 3
var randomTimerForActionEventInactivity = 75
var randomTimerForActionEventAcceptance = 10
