extends Node

var DEBUG_MODE = true

var gamePaused = false
var gameSpeed = 1
var gameTime= 0

var questions_file_path = "res://questions/example_question.json"
var questions_test_file_path = "res://questions/example_question_test.json"
var questions:Dictionary = {}

var terminalHistory = "";
