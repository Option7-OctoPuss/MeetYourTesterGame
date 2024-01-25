extends Node

var DEBUG_MODE = true

var gamePaused = false
var gameSpeed = 1
var gameTime= 0

var questions_file_path = "res://questions/example_question.json"
var questions:Dictionary = {}
var randomTimerForActionEventInactivity = 75
var randomTimerForActionEventAcceptance = 10
