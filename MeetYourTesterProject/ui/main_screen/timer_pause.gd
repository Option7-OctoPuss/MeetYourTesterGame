extends Node
var secondiDisponibili = 30

signal unpause_game_timer
# Called when the node enters the scene tree for the first time.
func _ready():
	if Globals.current_difficulty_level == 1:
		secondiDisponibili = 90 
	elif Globals.current_difficulty_level == 2:
			secondiDisponibili = 60
	else: secondiDisponibili = 30
	self.text = str(secondiDisponibili)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func _on_timer_node_timeout():
	if secondiDisponibili > 0:
		if Globals.gamePaused:
			secondiDisponibili -= 1
			self.text = str(secondiDisponibili) + " s"
			if secondiDisponibili == 0:
				Globals.gamePaused = false
				Globals.isPausable = false
				emit_signal("unpause_game_timer")

	
	pass


func _on_timer_pause_timeout():
	pass # Replace with function body.
