extends Node2D

var current_tutorial_screen_idx = 0;
var speed = 16
var current_step = 3
var tutorial_file_path = "res://static-data/tutorial-content/tutorial.json"
var tutorials_content = null
var tutorial_current_text = ""
var current_tutorial_content_length = 0
var current_tutorial_content = null
var json_keys = null
signal resume_game

func _ready():
	tutorials_content = JSON.parse_string(FileAccess.get_file_as_string(tutorial_file_path))
	json_keys = tutorials_content.keys()
	var current_tutorial_screen_key = tutorials_content.keys()[current_tutorial_screen_idx]
	current_tutorial_content_length = len(tutorials_content[current_tutorial_screen_key])
	change_tutorial_data()

func _physics_process(delta: float) -> void:
	var highlightSprite: Sprite2D = $HighlightIcon
	if current_step in range(0,15):
		highlightSprite.position.y += speed * delta
	else: 
		if current_step == -15:
			current_step = 15
			return
		$HighlightIcon.position.y -= speed * delta

	current_step -= 1

func change_scene(offset: int=1):
	var child_name = json_keys[current_tutorial_screen_idx]
	if current_tutorial_screen_idx <= 0 and offset < 0:
		return
	
	if current_tutorial_screen_idx >= len(json_keys)-1 and offset > 0:
		if Globals.start_tutorial == "main":
			get_tree().change_scene_to_file("res://ui/menus/main_menu.tscn")
			return
		
	
	# hide the current scene
	find_child(child_name).visible = false
		
	current_tutorial_screen_idx += offset
	child_name = json_keys[current_tutorial_screen_idx]
	# show new scene
	find_child(child_name).visible = true
	
	if current_tutorial_screen_idx + 1 == len(json_keys):
		if Globals.start_tutorial == "pause":
			$Popup/Next.visible = false
		else:
			$Popup/Next.texture_normal = ResourceLoader.load("res://images/tutorial-popup/tutorial_finish_base.svg")
			$Popup/Next.texture_hover = ResourceLoader.load("res://images/tutorial-popup/tutorial_finish_hover.svg")
	else:
		$Popup/Next.visible = true
		$Popup/Next.texture_normal = ResourceLoader.load("res://images/tutorial-popup/next-button.svg")
		$Popup/Next.texture_hover = ResourceLoader.load("res://images/tutorial-popup/next-button-select.svg")
		
	change_tutorial_data()

func _on_previous_pressed():
	change_scene(-1)

func _on_next_pressed():
	change_scene()
	
func change_tutorial_data() -> void:
	var current_tutorial_screen_key = json_keys[current_tutorial_screen_idx]
	current_tutorial_content = tutorials_content[current_tutorial_screen_key]
	tutorial_current_text = current_tutorial_content.text
	$HighlightIcon.rotation_degrees = current_tutorial_content.arrow_pos.rot
	$HighlightIcon.position = Vector2(current_tutorial_content.arrow_pos.x, current_tutorial_content.arrow_pos.y)
	$Popup/TutorialBody.set_text(tutorial_current_text)
	$Popup.scale = Vector2(current_tutorial_content.popup.scale, current_tutorial_content.popup.scale)
	$Popup.position = Vector2(current_tutorial_content.popup.pos.x, current_tutorial_content.popup.pos.y)
	$Popup/ProgressionText.text = str(current_tutorial_screen_idx + 1) + "/" + str(len(json_keys))
