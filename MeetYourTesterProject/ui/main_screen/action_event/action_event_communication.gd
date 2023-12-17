extends Node

func _send_to_terminal(_args:String):
	print("sending data")
	var text = _args
	var sibling_b = get_parent().get_node("TerminalMock")
	if sibling_b:
		print("Got the node" + sibling_b.name)
		sibling_b.handle_event_from_action_event(text)