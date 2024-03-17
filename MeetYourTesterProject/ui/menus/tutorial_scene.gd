extends Node2D

var current_tutorial_screen = "global_timing"
var speed = 16
var current_step = 3
var tutorial_file_path = "res://static-data/tutorial-content/tutorial.json"
var tutorials_content = null
var tutorial_current_text = ""
var current_idx_text = 0
var current_tutorial_content_length = 0
var arrow_position = null
var current_tutorial_content = null

func _ready():
	tutorials_content = JSON.parse_string(FileAccess.get_file_as_string(tutorial_file_path))
	current_tutorial_content_length = len(tutorials_content[current_tutorial_screen])
	current_tutorial_content = tutorials_content[current_tutorial_screen][current_idx_text]
	change_tutorial_data()


func _physics_process(delta: float) -> void:
	var highlightSprite: Sprite2D = find_child("HighlightIcon")
	if current_step in range(0,15):
		highlightSprite.position.y += speed * delta
	else: 
		if current_step == -15:
			current_step = 15
			return
		highlightSprite.position.y -= speed * delta

	current_step -= 1
	

func _on_previous_pressed():
	if current_idx_text > 0:	
		current_idx_text -= 1
		change_tutorial_data()


func _on_next_pressed():
	current_idx_text += 1
	
	if current_idx_text >= current_tutorial_content_length:
		print("Passa alla scena dopo")
		current_idx_text = 0
		return
	
	change_tutorial_data()
	
func change_tutorial_data() -> void:
	current_tutorial_content = tutorials_content[current_tutorial_screen][current_idx_text]
	tutorial_current_text = current_tutorial_content.text
	arrow_position = Vector2(current_tutorial_content.arrow_pos.x, current_tutorial_content.arrow_pos.y)
	find_child(current_tutorial_screen).find_child("TutorialBody").set_text(tutorial_current_text)
	find_child("HighlightIcon").position = arrow_position
