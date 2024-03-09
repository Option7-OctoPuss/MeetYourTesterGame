extends Control

var charge_count: int
var charge_limit_reached = Signal()
@onready var charge_count_label = find_child("SabotageChargesLabel")
@onready var progress_bar_control_node = get_parent().get_node("ProgressBarControl")
@onready var anonimity_node = get_parent().get_node("AnonymityBarControl")
@onready var charge_one_node: TextureRect = get_node("Charge1")
@onready var charge_two_node: TextureRect = get_node("Charge2")

# Called when the node enters the scene tree for the first time.
func _ready():
	progress_bar_control_node.connect("deadline_missed", _handle_deadline_missed)
	anonimity_node.connect("anon_value_update", _handle_anon_value_update)
	charge_count = 0

func _handle_anon_value_update():
	if Globals.current_anonymity_value >= Globals.ANON_VALUE_SABOTAGE_TRIGGER:
		if charge_count > 0:
			$SabotageButton.disabled = false

func _handle_deadline_missed():
	#GREAT SUCCESS
	print("Got a charge")
	increase_charge_count()
	change_label_text(str(charge_count))
	_handle_anon_value_update()
	
func increase_charge_count():
	if charge_count == 2:
		print("You have enough charges")
		emit_signal("charge_limit_reached")
		return

	charge_count += 1
	charge_count_label.text = str(charge_count)

	if charge_count == 1:
		charge_one_node.texture = load("res://images/sabotage-buttons/charge-filled.svg")
	else:
		charge_two_node.texture = load("res://images/sabotage-buttons/charge-filled.svg")
		

func change_label_text(new_text: String):
	charge_count_label.text = new_text

func decrease_charge_count():
	charge_count -= 1
	change_label_text(str(charge_count))
	if charge_count == 0:
		charge_one_node.texture = load("res://images/sabotage-buttons/charge-empty.svg")
	else:
		charge_two_node.texture = load("res://images/sabotage-buttons/charge-empty.svg")


func _on_sabotage_button_pressed():
	decrease_charge_count()
	anonimity_node.add_anonymity_value(-Globals.SABOTAGE_ANON_DECREASE_VALUE)
	decrease_final_deadline()
	if charge_count == 0:
		$SabotageButton.disabled = true
		return

func decrease_final_deadline():
	pass