extends Node

signal resume_game

func _ready():
	pass
	
func _process(delta):
	pass

func _on_quit_tutorial_pressed():
	$".".visible = false	
	resume_game.emit()
