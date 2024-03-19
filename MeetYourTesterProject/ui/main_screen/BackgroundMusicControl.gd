extends TextureButton

# Called when the node enters the scene tree for the first time.
func _ready():
	pass

func _toggled(toggled_on):
	if toggled_on:
		Globals.bg_music_volume = 0
	else:
		Globals.bg_music_volume = -80
	
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
