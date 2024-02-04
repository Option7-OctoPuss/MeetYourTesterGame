extends RichTextLabel

# TODO add animation form that plugin
# https://github.com/teebarjunk/godot-text_effects

@onready var tween = get_tree().create_tween()
var current_font_size = 14
var rng = RandomNumberGenerator.new()
var queue = [];
signal answer_signal(answer_target)

func _ready():
	self.clear()
	self.meta_underlined = false
	self.scroll_following = true
	
func retrieve_question(event_questions:Dictionary):
	var random_question_index = rng.randf_range(0, event_questions.questions.size()-1)
	return event_questions.questions[random_question_index]

func handle_event_from_action_event(event_name:String, event_questions:Dictionary):
	#animate_change_text(event_name, 14, 20, 2)
	
	var current_question = retrieve_question(event_questions)
	
	current_question['event_name'] = event_name # add property event_name to question
	queue.push_back(current_question)
	append_text(prepare_question_for_terminal(current_question))

	self.scroll_active = false 
	scroll_to_line(get_line_count() - 1)

func animate_change_text(_new_text, _start_size, _end_size, _duration) ->void:
	print("animate_change_text called")
	# http://man.hubwiz.com/docset/Godot.docset/Contents/Resources/Documents/tutorials/gui/bbcode_in_richtextlabel.html
	var animated_wave = "[wave amp=50 freq=2]%s[/wave]\n" % _new_text
	append_text(animated_wave)
	print("animate_change_text called 2")

func update_text_with_font_size(new_text, font_size) ->void:
	current_font_size = font_size
	var bbcode_str = "[size=" + str(font_size) + "]" + new_text + "[/size]"
	append_chat_line_escaped("test", bbcode_str)

func animate_font_size(_to_size, _duration) ->void:
	print("animate_font_size called")

func append_chat_line_escaped(username, message) ->void:
	append_text("%s: [color=green]%s[/color]\n" % [escape_bbcode(username), escape_bbcode(message)])

# Returns escaped BBCode that won't be parsed by RichTextLabel as tags.
func escape_bbcode(bbcode_text) -> String:
	# We only need to replace opening brackets to prevent tags from being parsed.
	return bbcode_text.replace("[", "[lb]")

func update_terminal_content(question_from_queue:Dictionary, answer_idx: int):
	Globals.terminalHistory += format_question(question_from_queue, answer_idx)
	self.set_text(Globals.terminalHistory)

	if queue.size() != 0:
		append_text(prepare_question_for_terminal(queue[0]))

func handle_meta_clicked(meta: Variant):
	self.scroll_active = true
	var question_choosed_info = meta.split('_') # questionId_answerIdx
	var question_from_queue = pop_selected_question(question_choosed_info[0].to_int())
	update_terminal_content(question_from_queue, question_choosed_info[1].to_int())
	print("Event name from meta: %s" % question_from_queue['event_name'])
	var node = get_node("../../../MainControl/" + question_from_queue['event_name'])	
	node.remove_action_event()
	var selected_answer = question_from_queue.answers[question_choosed_info[1].to_int()]
	if selected_answer != null:
		answer_signal.emit(selected_answer.target)

func prepare_question_for_terminal(question: Dictionary) -> String:
	var content_to_append = question.event_name + "\n" + "[color=red]%s[/color]\n"% question.title
	for i in range(question.answers.size()):
		content_to_append += "%s. [url=%s_%s]%s[/url]\n" % [i + 1, question.id, i, question.answers[i].text]
	return content_to_append + "\n"

func remove_bbcode_from_string(bbcode_string: String) -> String:
	var regex = RegEx.new()
	regex.compile("\\[.*?\\]")
	var text_without_tags = regex.sub(bbcode_string, "", true)
	return text_without_tags

func pop_selected_question(question_id: int) -> Dictionary:
	var idx = 0
	var question = {}
	
	for question_in_queue in queue:
		if question_id == question_in_queue.id:
			question = question_in_queue
			break
		idx += 1

	queue.remove_at(idx)
	return question

func format_question(question: Dictionary, answer_idx: int) -> String:
	var answers_text = []
	for answer in question.answers:
		answers_text.append(answer.text)

	var terminal_question = "[color=red]%s[/color]"% question.event_name + "\n" + question.title + "\n"
	for idx in range(0, answers_text.size()):
		if idx == answer_idx:
			terminal_question += "[color=green]%s[/color]"% (str(idx+1) + ". " + answers_text[idx]) + "\n"
		else:
			terminal_question += str(idx+1) + ". " + answers_text[idx] + "\n"

	return terminal_question + "\n"
