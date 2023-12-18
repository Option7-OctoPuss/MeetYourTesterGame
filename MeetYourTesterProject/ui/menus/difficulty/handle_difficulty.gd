extends TextureButton

# Exported variable for setting difficulty in the Editor
@export_category("Difficulty")
@export_enum("Easy:1", "Medium:2", "Hard:3", "Back:0") var difficulty_level = 0

@export_category("Next scene path")
@export_file("*.tscn") var next_scene_path = ""

#const next_scene = preload(next_scene_path)
# Called when the node enters the scene tree for the first time.
func _ready():
	self.pressed.connect(self._on_Button_pressed)

func _on_Button_pressed():
	DiffStore.player_difficulty = difficulty_level
	_debug_print("Button pressed with difficulty: %d" % difficulty_level)
	_debug_print("Difficulty stored in global: %d" % DiffStore.player_difficulty)
	# Change to the next scene
	if next_scene_path != "" || next_scene_path != null:
		_debug_print("Changing scene to: %s" % next_scene_path)
		SceneManager.change_scene(next_scene_path)
	else:
		_debug_print("Next scene path is not set.")

func _debug_print(msg):
	if Globals.DEBUG_MODE:
		print(msg)
