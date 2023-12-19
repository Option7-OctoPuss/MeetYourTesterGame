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
	get_parent()._send_to_terminal(modified_message)
