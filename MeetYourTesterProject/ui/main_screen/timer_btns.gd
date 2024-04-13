extends Node

signal pause_game
signal unpause_game
signal speed_up_game

var play_texture_path = preload("res://images/game-map/time/play.svg")
var pause_texture_path = preload("res://images/game-map/time/pause.svg")
var speed_texture_path = preload("res://images/game-map/time/speed.svg")
var speedup_texture_path = preload("res://images/game-map/time/speedup.svg")
var speedup_2_texture_path = preload("res://images/game-map/time/speedup2.svg")

# Called when the node enters the scene tree for the first time.
func _ready():
	self.pressed.connect(self._on_button_pressed)

func handle_play_pause():
	if Globals.gamePaused:
		changeImage()
		Globals.gamePaused = false
		emit_signal("unpause_game")
	else:
		if Globals.isPausable:
			changeImage()
			Globals.gamePaused = true
			emit_signal("pause_game")

func changeImage():
	if Globals.gamePaused:
		self.texture_normal = pause_texture_path
	else: 
		self.texture_normal = play_texture_path

func setImageNotPaused():
	self.texture_normal = pause_texture_path

func handle_speed_up():
	if Globals.gameSpeed == 1:
		self.texture_normal = speedup_texture_path
		Globals.gameSpeed = 2
		print("Speeding up")
	elif Globals.gameSpeed == 2:
		self.texture_normal = speedup_2_texture_path
		Globals.gameSpeed = 3
		print("Speeding up 2")
	elif Globals.gameSpeed == 3:
		Globals.gameSpeed = 1
		self.texture_normal = speed_texture_path
		print("Speeding up 3")
	else:
		print("Speeding up Else")
		Globals.gameSpeed = 1
		self.texture_normal = speed_texture_path
	emit_signal("speed_up_game")

# https://docs.godotengine.org/en/stable/getting_started/step_by_step/signals.html
func _on_button_pressed():
	if self.name == "PlayPauseBtn":
		handle_play_pause()
	elif self.name == "SpeedUpBtn":
		handle_speed_up()
	# print("Current game paused state: " + str(Globals.gamePaused))
	# print("Current game speed: " + str(Globals.gameSpeed))





