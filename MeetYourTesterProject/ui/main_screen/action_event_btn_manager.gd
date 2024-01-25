extends TextureButton

var state_disabled = true
@export_category("Communication message")
@export var message: String = "Test message"

# Called when the node enters the scene tree for the first time.
func _ready():
	randomize()
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
	
# TODO receive signal that this event was generated and this button must be enabled
func _on_timer_timeout():
	#print("action event is timeout")
	state_disabled = !state_disabled
	
	# Getting hexagon's timer child
	var timer_child = get_child(0).get_child(0)
	
	if !state_disabled:
		timer_child.wait_time = randi() % Globals.randomTimerForActionEventInactivity
	else:
		timer_child.wait_time = (randi() % Globals.randomTimerForActionEventAcceptance) + 5
	
	self.set_disabled(state_disabled)

# TODO change the disabled texture back to the normal one after receiving signal
# texture_disabled = preload("res://images/game-map/selected-hex/hex-cell-ui-ux-selected.svg")


func _pressed():
	#texture_disabled = preload("res://images/game-map/selected-hex/hex-cell-ui-ux-selected.svg")
	disabled = true
	# define the parameters to pass to the terminal
	var node_name = get_name()
	var params = {"node_name":node_name}
	# emit signal that this button has been pressed
	var terminal = get_parent().get_parent().get_node("Terminal").get_node("_terminal_mock")
	if terminal:
		terminal.handle_event_from_action_event(params)
