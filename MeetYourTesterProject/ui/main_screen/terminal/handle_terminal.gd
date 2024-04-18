extends RichTextLabel

# TODO add animation form that plugin
# https://github.com/teebarjunk/godot-text_effects

@onready var tween = get_tree().create_tween()
var rng = RandomNumberGenerator.new()
var queue = [];
var terminalHistory = ""
var REGEX_ENGINE = RegEx.new()
var last_meta_hover = ""
var last_meta_clicked = false
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
	#if queue.size() != 0:
		#text = prepare_question_for_terminal(event_name, current_question, true)

func handle_meta_clicked(meta: Variant):
	last_meta_clicked = true
	startSoundSelectedAnswer()
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
		
func _on_meta_hover_started(meta):
	if meta == last_meta_hover:
		return
	last_meta_hover = meta
	last_meta_clicked = false
	var text = self.get_text().split("[url=%s]" % meta)
	var text2 = text[1].split("[/url]")
	print(text2)
	var answer = "[color=yellow]%s[/color]" % text2[0]
	var t = text[0] + ("[url=%s]" % meta) + answer + text[1].substr(text[1].find("[/url]"))
	self.set_text(t)
	
func _on_meta_hover_ended(meta):
	last_meta_hover = ""
	if last_meta_clicked:
		return
	
	var text = self.get_text().split("[url=%s]" % meta)
	var text2 = text[1].split("[/url]")
	var answer = text2[0].split("[color=yellow]")[1].split("[/color]")[0]
	var t = text[0] + ("[url=%s]" % meta) + answer + text[1].substr(text[1].find("[/url]"))
	self.set_text(t)

func add_icons(answer):
	var ret = ""
	if "progress_bar" in answer:
		if "value" in answer.progress_bar:
			if answer.progress_bar.value > 0:
				ret += "[img width=25px]res://images/hints/progress_up.svg[/img]"
			else:
				ret += "[img width=25px]res://images/hints/progress_down.svg[/img]"
		if "zone" in answer.progress_bar and "speedValue" in answer.progress_bar.zone:
			if answer.progress_bar.zone.speedValue > 1:
				ret += "[img width=25px]res://images/hints/zone_down.svg[/img]"
			else:
				ret += "[img width=25px]res://images/hints/zone_up.svg[/img]"
	if "anon_bar" in answer:
		if "value" in answer.anon_bar:
			if answer.anon_bar.value > 0:
				ret += "[img width=25px]res://images/hints/anonimity_up.svg[/img]"
			else:
				ret += "[img width=25px]res://images/hints/anonimity_down.svg[/img]"

	return ret


func prepare_question_for_terminal(event_name: String, question: Dictionary, with_url: bool=false, answered_idx: int=- 1) -> String:
	var content_to_append = "[color=red]%s[/color]\n%s\n\n" % [event_name, check_for_characters(question.title)]
	var aftermath_color = "#FFB6C1"
	for i in range(question.answers.size()):
		var answer_text = question.answers[i].text
		var icons_string = ''
		if Globals.current_difficulty_level == 1:
			icons_string = add_icons(question.answers[i]) 
		if with_url:
			content_to_append += "%s. [url=%s_%s]%s[/url]" % [i + 1, question.id, i, icons_string + answer_text]
		else:
			if i == answered_idx:
				content_to_append += "[color=green]%s. %s[/color]" % [i + 1, icons_string + answer_text]
			else:
				content_to_append += "%s. %s" % [i + 1, icons_string + answer_text]
		content_to_append += "\n"
	if answered_idx != - 1:
		var aftermath_text = question.answers[answered_idx].get("aftermath", null)
		if aftermath_text != null:
			content_to_append += "[color=%s]%s[/color]\n" % [aftermath_color, aftermath_text]
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

func check_for_characters(question_title: String, persona_color: String="#05C9C9") -> String:
	var regex_pattern: String = "%(.*?)%"
	REGEX_ENGINE.compile(regex_pattern)
	var results = REGEX_ENGINE.search_all(question_title)
		
	for result in results:
		var matched_string = result.get_string(0)
		print("matched_string %s" % matched_string)
		var matched_string_replaced = result.get_string(1)
		question_title = question_title.replace(matched_string, "[wave amp=50.0 freq=5.0 connected=1][color=%s]" % persona_color + matched_string_replaced + "[/color][/wave]")
	
	return question_title


func startSoundSelectedAnswer():
	get_node("../TerminalSelectedAnswerSfx").play()






