extends TextureButton

var sound_clicked : AudioStreamPlayer
var sound_activated : AudioStreamPlayer
var sound_selected : AudioStreamPlayer

# Called when the node enters the scene tree for the first time.
func _ready():
	sound_clicked = $"../../MainControl/HexagonClickedSfx"
	sound_activated = $"../../MainControl/HexagonActivatedSfx"
	sound_selected = $"../../Terminal/_terminal_mock/TerminalSelectedAnswerSfx"

func _toggled(toggled_on):
	if toggled_on:
		sound_clicked.volume_db = -10
		sound_activated.volume_db = -10
		sound_selected.volume_db = -10
		Globals.sound_fx_volume = -10
	else:
		sound_clicked.volume_db = -80
		sound_activated.volume_db = -80
		sound_selected.volume_db = -80
		Globals.sound_fx_volume = -80

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
