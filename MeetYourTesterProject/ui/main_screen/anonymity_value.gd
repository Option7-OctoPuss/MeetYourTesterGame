extends Control
 
@onready var terminal = $"../Terminal/_terminal_mock/terminal_content"
signal anon_value_update

func _ready():
	terminal.connect("answer_signal", handle_answer_signal)
 
func handle_answer_signal(selected_answer: Dictionary):
	# check if the signal is for anonimity bar
	if selected_answer.has(Globals.ANONYMITY_BAR_DICTIONARY_KEY):
		# expose value to parse it globally
		add_anonymity_value(selected_answer[Globals.ANONYMITY_BAR_DICTIONARY_KEY].value)
		if Globals.current_anonymity_value > Globals.anonymity_value_alert_threshold:
			print("Anonymity bar threshold passed")
		

func add_anonymity_value(value: int):
	Globals.current_anonymity_value += value
	if Globals.current_anonymity_value > Globals.max_anonimity_value:
		Globals.current_anonymity_value = Globals.max_anonimity_value	
	self.get_child(0).set_text("Anonimity: %s" % Globals.current_anonymity_value)
	anon_value_update.emit()
