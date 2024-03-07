extends Node2D

const title_sabotage = "SABOTAGE SUCCESSFUL"
const title_deadline = "PROJECT DELIVERED"
const title_anonymity = "YOU HAVE BEEN EXPOSED"

const body_sabotage = "Congratulations, Master Saboteur! 
You’ve outwitted the clock, danced with deadlines, and slipped through the shadows undetected. 
The final project is in shambles and the world will never know your name, but they’ll forever feel the tremors of your clandestine triumph.

Farewell, enigmatic saboteur. May your next venture be as treacherous as the one you’ve just unraveled.

Ready for another round? The game awaits."
const body_deadline = "The CEO approaches, eyes gleaming with pride. 
  “The Project is a masterpiece.” he declares.
  “The stakeholders love it and it’s complete ahead of schedule!”

Your sabotage has failed, yet your secret identity remains safe.
As you exit, he whispers: 
  “Sometimes, failure is the greatest art of all.”

Ready for another round? The game awaits."
const body_anonymity = "The CEO, stern-faced and unyielding, steps into the room. His words slice through the tension like a well-honed blade:
  
  “Your contract? Consider it… vaporized.”

And just like that, you’re out of the game, your covert escapades exposed. The exit door awaits, your clandestine journey cut short.

Ready for another round? The game awaits."

var titleLabel : Label
var bodyLabel : Label
var background : TextureRect

# Called when the node enters the scene tree for the first time.
func _ready():
	titleLabel = $title
	bodyLabel = $body
	background = $bg
	
	# TODO use the actual value from the signal inside the match
	var signal_mock: int = 1
	match signal_mock:
		1:
			titleLabel.text = title_sabotage
			bodyLabel.text = body_sabotage
			background.texture = ResourceLoader.load("res://images/end-game/end-screen-sabotage.svg")
		2:
			titleLabel.text = title_anonymity
			bodyLabel.text = body_anonymity
			background.texture = ResourceLoader.load("res://images/end-game/end-screen-anonymity.svg")
		3:
			titleLabel.text = title_deadline
			bodyLabel.text = body_deadline
			background.texture = ResourceLoader.load("res://images/end-game/end-screen-deadline.svg")

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
