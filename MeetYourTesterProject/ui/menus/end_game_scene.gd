extends Node2D

var titleLabel : Label
var bodyLabel : Label
var background : TextureRect

# Called when the node enters the scene tree for the first time.
func _ready():
	titleLabel = $title
	bodyLabel = $body
	background = $bg
	
	var messages = JSON.parse_string(FileAccess.get_file_as_string("%s" % Globals.messages_file_path))

	# TODO use the actual value from the signal inside the match
	match Globals.end_game_reason:
		1:
			titleLabel.text = messages.sabotage.title
			bodyLabel.text = messages.sabotage.body
			background.texture = ResourceLoader.load("res://images/end-game/end-screen-sabotage.svg")
		2:
			titleLabel.text = messages.anonimity.title
			bodyLabel.text = messages.anonimity.body
			background.texture = ResourceLoader.load("res://images/end-game/end-screen-anonymity.svg")
		3:
			titleLabel.text = messages.deadline.title
			bodyLabel.text = messages.deadline.body
			background.texture = ResourceLoader.load("res://images/end-game/end-screen-deadline.svg")

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func _on_restart_game_button_pressed():
	get_tree().change_scene_to_file("res://ui/main_screen/main_game_scene.tscn")

func _on_back_to_menu_button_pressed():
	get_tree().change_scene_to_file("res://ui/menus/main_menu.tscn")
