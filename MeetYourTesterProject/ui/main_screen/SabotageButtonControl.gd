extends Control

var charge_count: int
var charge_limit_reached = Signal()
@onready var charge_count_label = find_child("SabotageChargesLabel")
@onready var progress_bar_control_node = get_parent().get_node("ProgressBarControl")
@onready var anonimity_node = get_parent().get_node("AnonymityBarControl")
@onready var charge_one_node: TextureRect = get_node("Charge1")
@onready var charge_two_node: TextureRect = get_node("Charge2")
@onready var anon_bar = $SabotageButton/AnonymityBar

# Called when the node enters the scene tree for the first time.
func _ready():
	progress_bar_control_node.connect("deadline_missed", _handle_deadline_missed)
	anonimity_node.connect("anon_value_update", _handle_anon_value_update)
	charge_count = 0

func _handle_anon_value_update():
	anon_bar.value = Globals.current_anonymity_value
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
	reduce_deadline_time()
	decrease_charge_count()
	anonimity_node.add_anonymity_value(-Globals.SABOTAGE_ANON_DECREASE_VALUE)
	if charge_count == 0:
		$SabotageButton.disabled = true
		return

func reduce_deadline_time():
	var deadlines_children = progress_bar_control_node.find_child("DeadlinesContainer").get_children()
	for deadline_node in deadlines_children:
		var deadline_texture: TextureRect = deadline_node.find_child("Deadline")
		var deadline_label: Label = deadline_node.find_child("DeadlineTimer") 
		var new_deadline_time_amount = Utils.time_to_seconds(deadline_label.text) - Globals.DECREASE_FINAL_DEADLINE_AMOUNT
		
		if new_deadline_time_amount <= 0:
			pass

		if deadline_texture.texture.resource_path.contains("pending"):
			deadline_label.text = Utils.float_to_time(new_deadline_time_amount)
			break
