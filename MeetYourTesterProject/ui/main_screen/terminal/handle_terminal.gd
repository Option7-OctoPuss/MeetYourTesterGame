extends RichTextLabel

# TODO add animation form that plugin
# https://github.com/teebarjunk/godot-text_effects

@onready var tween = get_tree().create_tween()
var current_font_size = 14

func _ready():
	self.clear()

func handle_event_from_action_event(_message:String):
	print("handle_event_from_action_event called")
	animate_change_text(_message, 14, 20, 2)



func animate_change_text(_new_text, _start_size, _end_size, _duration) ->void:
	print("animate_change_text called")
	# http://man.hubwiz.com/docset/Godot.docset/Contents/Resources/Documents/tutorials/gui/bbcode_in_richtextlabel.html
	var animated_wave = "[wave amp=50 freq=2]%s[/wave]\n" % _new_text
	append_chat_line_escaped("test user", _new_text)
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