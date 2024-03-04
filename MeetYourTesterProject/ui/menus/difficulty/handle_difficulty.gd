extends TextureButton

# Exported variable for setting difficulty in the Editor
@export_category("Difficulty")
@export_enum("Cancel:0", "Easy:1", "Medium:2", "Hard:3") var difficulty_level = 0

@export_category("Next scene path")
@export_file("*.tscn") var next_scene_path = ""

#const next_scene = preload(next_scene_path)

# Called when the node enters the scene tree for the first time.
func _ready():
	self.pressed.connect(self._on_Button_pressed)

func _on_Button_pressed():
	DiffStore.player_difficulty = difficulty_level
	if difficulty_level > 0:
		print('set speed to %s' %ProgressBarGlobals.progress_bar_possible_speeds[difficulty_level - 1])
		ProgressBarGlobals.progress_bar_speed = ProgressBarGlobals.progress_bar_possible_speeds[difficulty_level - 1]
		
		# save current difficulty deadlines 
		var file = FileAccess.get_file_as_string(Globals.deadlines_file_path)
		if file:
			var parse_json_file = JSON.parse_string(file)
			Globals.deadlines = parse_json_file["difficulty-%s" % difficulty_level]
		else:
			Globals.deadlines = []
			
	_debug_print("Button pressed with difficulty: %d" % difficulty_level)
	_debug_print("Difficulty stored in global: %d" % DiffStore.player_difficulty)
	# Change to the next scene
	if next_scene_path != ""||next_scene_path != null:
		_debug_print("Changing scene to: %s" % next_scene_path)
		SceneManager.change_scene(next_scene_path)
	else:
		_debug_print("Next scene path is not set.")

func _debug_print(msg):
	if Globals.DEBUG_MODE:
		print(msg)
