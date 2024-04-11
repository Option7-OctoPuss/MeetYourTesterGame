extends TextureButton

var exit_menu
@export_category("Communication message")
@export var message: String = "Test message"
var backup_disable_image: Texture2D
var backup_hover_image: Texture2D
var is_action_event_generated = false
var timer_child = null

signal hexagon_clicked(params)

# Called when the node enters the scene tree for the first time.
func _ready():
	randomize()
	backup_disable_image = texture_disabled	
	backup_hover_image = texture_hover
	timer_child = get_child(0).get_child(0)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
	
func _on_timer_timeout():
	if !is_action_event_generated:
		startSoundSpawnEvent()
		generate_action_event()
	else:
		remove_action_event()

func _pressed():
	# to switch texture, we first save the disabled one, then replace it with the pressed one
	texture_disabled = texture_pressed
	disabled = true
	# define the parameters to pass to the terminal
	var node_name = get_name()
	var params = {"node_name": node_name}
	# emit signal that this button has been pressed
	hexagon_clicked.emit(params)
	startSoundClickedEvent()

func cancel_pressed():
	if is_action_event_generated:
		disabled = true
		is_action_event_generated = false
		texture_disabled = backup_disable_image		
		timer_child.wait_time = randi() % Globals.randomTimerForActionEventInactivity
		timer_child.start()
		timer_child.handle_cancel()

# functions to handle changes of state for the button
func generate_action_event():
	disabled = false
	is_action_event_generated = true
	timer_child.wait_time = randi() % Globals.randomTimerForActionEventAcceptance
	
func remove_action_event():
	texture_disabled = backup_disable_image
	disabled = true
	is_action_event_generated = false
	if timer_child:
		timer_child.stop()
		timer_child.wait_time = randi() % Globals.randomTimerForActionEventInactivity
		timer_child.start()
	
func startSoundSpawnEvent():
	get_node("../HexagonActivatedSfx").play()
	
func startSoundClickedEvent():
	get_node("../HexagonClickedSfx").play()

func handle_game_exit(checkGameQuit):
	if(checkGameQuit):
		if(disabled and is_action_event_generated):
			texture_hover = texture_pressed
		if(disabled and not is_action_event_generated):
			texture_hover = texture_disabled
		if(not disabled):
			texture_hover = texture_normal
	else: 
		texture_hover = backup_hover_image
