extends Control

func _ready():
	pass



func _on_timer_timeout():
	$GameProgressBar.value += 0.1


func apply_answer_effects():
	print("Answer Selected!")
	var currentAnswer = Globals.currentAnswer
	match currentAnswer.type:
		"progress_bar":
			apply_progress_bar_effects(currentAnswer.effects)
		"anon_bar": 
			apply_progress_anon_bar(currentAnswer.effects)
			

func apply_progress_bar_effects(currentAnswer: Dictionary) -> void:
    # Check for existing Zone
    # if exists create Zone
    # Retrieve the current value of the progress and calculate the offset for the Zone
    # Godot handle under the hood the check for progress bar boundaries. If you add 1000 with a max value of 100 it will be 100.
	$GameProgressBar.value += currentAnswer.value  


func apply_progress_anon_bar(currentAnswer: Dictionary) -> void:
	pass    
            