extends Node2D

var current_tutorial_screen_idx = 0;
var speed = 16
var current_step = 3
var tutorial_file_path = "res://static-data/tutorial-content/tutorial.json"
var tutorials_content = null
var tutorial_current_text = ""
var current_tutorial_content_length = 0
var current_tutorial_content = null

func _ready():
	tutorials_content = JSON.parse_string(FileAccess.get_file_as_string(tutorial_file_path))
	var current_tutorial_screen_key = tutorials_content.keys()[current_tutorial_screen_idx]
	current_tutorial_content_length = len(tutorials_content[current_tutorial_screen_key])
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

func change_scene(offset: int=1):
	if current_tutorial_screen_idx <= 0 and offset < 0:
		return
	
	if current_tutorial_screen_idx >= len(tutorials_content.keys())-1 and offset > 0:
		get_tree().change_scene_to_file("res://ui/menus/main_menu.tscn")
		return
	
	# hide the current scene
	find_child(tutorials_content.keys()[current_tutorial_screen_idx]).visible = false
	current_tutorial_screen_idx += offset
		
	
	# show new scene
	find_child(tutorials_content.keys()[current_tutorial_screen_idx]).visible = true
	
	change_tutorial_data()

func _on_previous_pressed():
	change_scene(-1)

func _on_next_pressed():
	change_scene()
	
func change_tutorial_data() -> void:
	var current_tutorial_screen_key = tutorials_content.keys()[current_tutorial_screen_idx]
	current_tutorial_content = tutorials_content[current_tutorial_screen_key]
	tutorial_current_text = current_tutorial_content.text
	$HighlightIcon.rotation_degrees = current_tutorial_content.arrow_pos.rot
	$HighlightIcon.position = Vector2(current_tutorial_content.arrow_pos.x, current_tutorial_content.arrow_pos.y)
	#find_child(tutorials_content.keys()[current_tutorial_screen_idx]).find_child("TutorialBody").set_text(tutorial_current_text)
	$Popup/TutorialBody.set_text(tutorial_current_text)
	$Popup.scale = Vector2(tutorials_content[current_tutorial_screen_key]["popup"]["scale"], tutorials_content[current_tutorial_screen_key]["popup"]["scale"])
	$Popup.position = Vector2(tutorials_content[current_tutorial_screen_key]["popup"]["pos"]["x"], tutorials_content[current_tutorial_screen_key]["popup"]["pos"]["y"])
