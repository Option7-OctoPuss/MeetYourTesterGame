extends TextureButton


@export_category("Communication message")
@export var message: String = "Test message"
var backup_disable_image: Texture2D
var is_action_event_generated = false
var timer_child = null
#var is_action_event_generated = {
	#"Database":false,
	#"Delivery":false,
	#"BusinessLogic":false,
	#"Backend":false,
	#"UI_UX":false,
#}

# Called when the node enters the scene tree for the first time.
func _ready():
	randomize()
	backup_disable_image = texture_disabled	
	timer_child = get_child(0).get_child(0)
	


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
	
# TODO receive signal that this event was generated and this button must be enabled
# TODO receive signal that this event was generated and this button must be enabled
func _on_timer_timeout():
	# Getting hexagon's timer child
	if !is_action_event_generated:
		generate_action_event()
	else:
		remove_action_event()

func _pressed():
	#is_action_event_generated = true
	# to switch texture, we first save the disabled one, then replace it with the pressed one
	texture_disabled = texture_pressed
	disabled = true
	timer_child.paused = true
	# define the parameters to pass to the terminal
	var node_name = get_name()
	var params = {"node_name":node_name}
	# emit signal that this button has been pressed
	var terminal = get_parent().get_parent().get_node("Terminal").get_node("_terminal_mock")
	if terminal:
		terminal.handle_event_from_action_event(params)

# functions to handle changes of state for the button
func generate_action_event():
	print("generating for "+name)
	disabled = false
	is_action_event_generated = true
	timer_child.wait_time = randi() % Globals.randomTimerForActionEventAcceptance
	
	

func remove_action_event():
	print("removing for "+name)
	texture_disabled = backup_disable_image
	print(disabled)
	disabled = true
	is_action_event_generated = false
	timer_child.stop()
	timer_child.wait_time = randi() % Globals.randomTimerForActionEventInactivity
	timer_child.start()
	timer_child.paused = false
	
	
	
	
