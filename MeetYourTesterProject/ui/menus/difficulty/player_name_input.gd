extends LineEdit


func _on_line_edit_text_entered(new_text):
	# Sanitize input
	var escaped_text = new_text.c_escape()
	
	print("Text entered: ", escaped_text)
	if (escaped_text == ""):
		emit_signal("empty_name", true)
		escaped_text = "Player"
	else:
		emit_signal("empty_name", false)
	diff_store.player_name = escaped_text

func _ready():
	self.connect("text_changed", _on_line_edit_text_entered)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
