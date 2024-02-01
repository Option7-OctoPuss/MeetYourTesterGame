extends Control

@onready var terminal = $"../Terminal/_terminal_mock/terminal_content"
const PROGRESS_BAR_DICTIONARY_KEY = "progress_bar"

func _ready():
	terminal.connect("answer_signal", apply_progress_bar_effects)


func apply_progress_bar_effects(answer_impact: Dictionary):
	if PROGRESS_BAR_DICTIONARY_KEY == answer_impact["type"]:
		print("Answer Selected!")
		var answerEffects = answer_impact["effects"]
		
		if answerEffects.has("zone"):
			create_zone(answerEffects)

		# Godot handle under the hood the check for progress bar boundaries. If you add 1000 with a max value of 100 it will be 100.
		$GameProgressBar.value += answerEffects.value

func create_zone(answer_effects: Dictionary):
	pass
