extends TextureButton
@export_category("Shaders")
@export var normal_shader: Material
@export var disabled_shader: Material

# This should be taken from message_pool/or message_manager
@export_category("Communication message")
@export var message: String = "Test message"

var state_disabled = false

func _pressed():
	var modified_message = message+ " -> " + str(randf())
	print("action event is pressed")
	get_parent()._send_to_terminal(modified_message)


func on_Timer_timeout():
	print("action event is timeout")
	state_disabled = !state_disabled
	self.set_disabled(state_disabled)
	self.set_material( disabled_shader if state_disabled else normal_shader)

