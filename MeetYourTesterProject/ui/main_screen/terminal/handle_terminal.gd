extends RichTextLabel

# TODO add animation form that plugin
# https://github.com/teebarjunk/godot-text_effects

@onready var tween = get_tree().create_tween()
var current_font_size = 14
var rng = RandomNumberGenerator.new()
var queue = [];

func _ready():
	self.clear()
	self.meta_underlined = false
	self.scroll_following = true

func handle_event_from_action_event(event_name:String, event_questions:Dictionary):
	# TODO: show both event_name and event_questions in the terminal, with correct node structure and formatting
	#animate_change_text(event_name, 14, 20, 2)
	print("TODO: show to terminal one of these event questions " + str(event_questions))

	# TODO: Logic to retrieve a question from event_questions. Random for now
	var random_question_index = rng.randf_range(0, event_questions.questions.size()-1)
	var current_question = event_questions.questions[random_question_index]
	
	var question_formatted = prepare_question_for_terminal(event_name, current_question)
	queue.push_back({"question_id" : current_question.id, "question_formatted": question_formatted, "question": current_question})
	append_text(question_formatted)
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

func _on_meta_clicked(meta):
	self.scroll_active = true
	var question_choosed_info = meta.split('_') # questionId_answerIdx
	print(question_choosed_info)

	var question_from_queue = get_question_from_queue(question_choosed_info[0].to_int())
	remove_question_from_queue(question_choosed_info[0].to_int())

	Globals.terminalHistory += remove_bbcode_from_string(question_from_queue[1])

	self.set_text(Globals.terminalHistory + "\n\n")

	if queue.size() != 0:
		append_text(queue[0].question_formatted)

	# TODO: retrieve answer from question_from_queue[0] based on answer index (question_choosed_info[1]) and send values

func prepare_question_for_terminal(event_name: String, question: Dictionary) -> String:
	var content_to_append = event_name + "\n" + "[color=red]%s[/color]\n"% question.title
	for i in range(question.answers.size()):
		content_to_append += "%s. [url=%s_%s]%s[/url]\n" % [i, question.id, i, question.answers[i].text]
	return content_to_append

func remove_bbcode_from_string(bbcode_string: String) -> String:
	var regex = RegEx.new()
	regex.compile("\\[.*?\\]")
	var text_without_tags = regex.sub(bbcode_string, "", true)
	return text_without_tags

# Return an array containing the question object and its formatted version if found
func get_question_from_queue(question_id: int) -> Array:
	for question_in_queue in queue:
		if question_id == question_in_queue.question_id:
			return [question_in_queue.question, question_in_queue.question_formatted]
	return []

func remove_question_from_queue(question_id: int) -> void:
	for i in range(queue.size()):
		if question_id == queue[i].question_id:
			queue.remove_at(i)
			return
