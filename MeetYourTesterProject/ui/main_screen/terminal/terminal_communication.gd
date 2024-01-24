extends Node2D

@export var event_node_name:String = ""

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


func handle_event_from_action_event(event_params:Dictionary):
	event_node_name = event_params["node_name"]
	$terminal_content.handle_event_from_action_event(event_node_name)
	var answer_mockup = get_parent().get_node("_answer_mockup")
	answer_mockup.visible = true
	answer_mockup.disabled = false
