extends Control

var charge_count: int
var charge_limit_reached = Signal()
@onready var charge_count_label = find_child("SabotageChargesLabel")
@onready var progress_bar_control_node = get_parent().get_node("ProgressBarControl")

# Called when the node enters the scene tree for the first time.
func _ready():
	progress_bar_control_node.connect("deadline_missed", _handle_deadline_missed)
	charge_count = 0

func _handle_deadline_missed():
	#GREAT SUCCESS
	print("Got a charge")
	if charge_count < 3:
		charge_count += 1
		charge_count_label.text = str(charge_count)
	else:
		print("You have enough charges")
		emit_signal("charge_limit_reached")
