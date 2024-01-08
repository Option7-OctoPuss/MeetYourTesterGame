extends TextureButton

var state_disabled = true
@export_category("Communication message")
@export var message: String = "Test message"

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
	
func _on_timer_timeout():
	print("action event is timeout")
	state_disabled = !state_disabled
	self.set_disabled(state_disabled)


func _pressed():
	var modified_message = message+ " -> " + str(randf())
	print("action event is pressed")
	print("sending data")
	var text = modified_message
	var sibling_b = get_parent().get_parent().get_node("Terminal").get_node("_terminal_mock")
	if sibling_b:
		print("Got the node" + sibling_b.name)
		sibling_b.handle_event_from_action_event(text)


func _on_pressed():
	pass # Replace with function body.
