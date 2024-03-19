extends Node

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	$Music.volume_db = Globals.bg_music_volume
