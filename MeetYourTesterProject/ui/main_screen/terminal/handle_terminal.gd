extends RichTextLabel

# TODO add animation form that plugin
# https://github.com/teebarjunk/godot-text_effects

@onready var tween = get_tree().create_tween()
var rng = RandomNumberGenerator.new()
var queue = [];
var terminalHistory = ""
var REGEX_ENGINE = RegEx.new()
signal answer_signal(answer_target)

func _ready():
	self.clear()
	self.meta_underlined = false
	self.scroll_following = true
	
func retrieve_question(event_questions: Array):
	if event_questions.size() > 0:
		var random_question_index = rng.randi_range(0, event_questions.size() - 1)
		return event_questions[random_question_index]

# Start here
func handle_event_from_action_event(event_name: String, event_questions: Array):
	var current_question = retrieve_question(event_questions)
	if not current_question:
		return
	
	current_question.answers = randomize_answers(current_question.answers)
	# push to queue both current event_name and question content
	queue.append([event_name, current_question])
	text = prepare_question_for_terminal(event_name, current_question, true)
	self.scroll_active = false
	scroll_to_line(get_line_count() - 1)

func update_terminal_content(event_name: String, current_question: Dictionary, answer_idx: int):
	terminalHistory += prepare_question_for_terminal(event_name, current_question, false, answer_idx)
	text = terminalHistory
	if queue.size() != 0:
		text = prepare_question_for_terminal(event_name, current_question, true)

func handle_meta_clicked(meta: Variant):
	self.scroll_active = true
	var question_choosed_info = meta.split('_') # questionId_answerIdx
	print(question_choosed_info)
	var question_from_queue = pop_selected_question(question_choosed_info[0])
	print(question_from_queue)
	var event_name = question_from_queue[0]
	var current_question = question_from_queue[1]
	update_terminal_content(event_name, current_question, question_choosed_info[1].to_int())
	#print("Event name from meta: %s" % question_from_queue['event_name'])
	var node = get_node("../../../MainControl/"+ event_name)
	if node:
		node.remove_action_event()
	var selected_answer = current_question.answers[question_choosed_info[1].to_int()]
	if selected_answer != null:
		# add node_name to selected answer for correct behaviour in pause/resume hexagon timer
		selected_answer.node_name = event_name
		Globals.currentAnswer = selected_answer
		answer_signal.emit(selected_answer)

func prepare_question_for_terminal(event_name: String, question: Dictionary, with_url: bool=false, answered_idx: int=- 1) -> String:
	var content_to_append = "[color=red]%s[/color]\n%s\n\n" % [event_name, check_for_characters(question.title)]
	for i in range(question.answers.size()):
		var answer_text = question.answers[i].text
		if with_url:
			content_to_append += "%s. [url=%s_%s]%s[/url]" % [i + 1, question.id, i, answer_text]
		else:
			if i == answered_idx:
				content_to_append += "[color=green]%s. %s[/color]" % [i + 1, answer_text]
			else:
				content_to_append += "%s. %s" % [i + 1, answer_text]
		content_to_append += "\n"
	if answered_idx != - 1:
		var aftermath_text = question.answers[answered_idx].get("aftermath", null)
		if aftermath_text != null:
			content_to_append += "[color=#FFB6C1]%s[/color]\n" % aftermath_text
	return content_to_append + "\n"

func randomize_answers(answers: Array, amount: int=3) -> Array:
	if answers.size() <= amount: return answers
		
	var randomized_answers: Array = []
	for i in range(amount):
		var random_index = rng.randi_range(0, answers.size() - 1)
		randomized_answers.append(answers[random_index])
		answers.remove_at(random_index)
	return randomized_answers

func pop_selected_question(question_id: String) -> Array:
	for i in range(queue.size()):
		if question_id == queue[i][1].id:
			return queue.pop_at(i)
	return []

func check_for_characters(question_title: String) -> String:
	var regex_pattern: String = "%(.*?)%"
	REGEX_ENGINE.compile(regex_pattern)
	var results = REGEX_ENGINE.search_all(question_title)
		
	for result in results:
		var matched_string = result.get_string(0)
		print("matched_string %s" % matched_string)
		var matched_string_replaced = result.get_string(1)
		question_title = question_title.replace(matched_string, "[wave amp=50.0 freq=5.0 connected=1][color=blue]" + matched_string_replaced + "[/color][/wave]")
	
	return question_title
