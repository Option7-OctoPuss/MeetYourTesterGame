extends Control
 
@onready var terminal = $"../Terminal/_terminal_mock/terminal_content"
 
const ANONYMITY_BAR_DICTIONARY_KEY = "anon_bar"
 
func _ready():
	terminal.connect("answer_signal", handle_answer_signal)
 
func handle_answer_signal(selected_answer: Dictionary):
	# check if the signal is for anonimity bar
	if selected_answer.has(ANONYMITY_BAR_DICTIONARY_KEY):
		# expose value to parse it globally
		Globals.current_anonymity_value += selected_answer[ANONYMITY_BAR_DICTIONARY_KEY].value
		# TODO: replace set_text with logic to update anonymity bar
		self.get_child(0).set_text("Anonimity: %s" % Globals.current_anonymity_value)
		if Globals.current_anonymity_value > Globals.anonymity_value_alert_threshold:
			print("Anonymity bar threshold passed")
