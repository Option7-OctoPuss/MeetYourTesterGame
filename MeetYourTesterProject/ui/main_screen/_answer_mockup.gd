extends Button


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

# mockup to handle selection of an answer
# for now it gets the node name and deactivates the action event button
func _pressed():
	var node_name = get_parent().get_node("_terminal_mock").event_name
	var node = get_node("../../MainControl/" + node_name)
	print("mockup answer selected for node "+node_name)
	
	node.remove_action_event()
	
	visible=false
	disabled=true
