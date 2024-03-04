extends Node

var DEBUG_MODE = true

var gamePaused = false
var gameSpeed = 1
var gameTime = 0

var deadlines_file_path = "res://deadlines/Deadlines.json"
var deadlines: Array

var questions_dir_path = "res://questions"
var questions_file_path = "res://questions/example_question.json"
var questions_test_file_path = "res://questions/example_question_test.json"
var questions: Dictionary = {}

var terminalHistory = "";
var currentAnswer: Dictionary = {}

var current_anonymity_value = 0
var anonymity_value_alert_threshold = 4

var randomTimerForActionEventInactivity = 10 # 75
var randomTimerForActionEventAcceptance = 10

const ANONYMITY_BAR_DICTIONARY_KEY = "anon_bar"
