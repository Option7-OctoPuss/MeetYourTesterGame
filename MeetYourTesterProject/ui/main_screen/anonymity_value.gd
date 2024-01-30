extends Control
 
@onready var terminal = $"../Terminal/_terminal_mock/terminal_content"
 
const ANONYMITY_BAR_DICTIONARY_KEY = "anon_bar"
 
func _ready():
	terminal.connect("answer_signal", handle_answer_signal)
 
func handle_answer_signal(answer_impact: Dictionary):
	# check if the signal is for anonimity bar
	if ANONYMITY_BAR_DICTIONARY_KEY == answer_impact["type"]:
		# expose value to parse it globally
		Globals.current_anonymity_value += answer_impact["effects"]["value"]
		
		# TODO: replace set_text with logic to update anonymity bar
		self.get_child(0).set_text("Anonimity: %s" % Globals.current_anonymity_value)
		if Globals.current_anonymity_value > Globals.anonymity_value_alert_threshold:
			print("Anonymity bar threshold passed")
