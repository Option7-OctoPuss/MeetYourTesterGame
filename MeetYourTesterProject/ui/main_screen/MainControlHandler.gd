extends Control

var listHexagons = []
var selectedNode

signal selectedAnotherAnswer(params)
# Called when the node enters the scene tree for the first time.
func _ready():
	listHexagons.append(get_node("Delivery"))
	listHexagons.append(get_node("Database"))
	listHexagons.append(get_node("Backend"))
	listHexagons.append(get_node("Business_Logic"))
	listHexagons.append(get_node("UI_UX"))
	
	get_node("Delivery").connect("hexagon_clicked", handlerClickFunction)
	get_node("Backend").connect("hexagon_clicked", handlerClickFunction)
	get_node("Business_Logic").connect("hexagon_clicked", handlerClickFunction)
	get_node("UI_UX").connect("hexagon_clicked", handlerClickFunction)
	get_node("Database").connect("hexagon_clicked", handlerClickFunction)
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func handlerClickFunction(params):
	if selectedNode == null:
		selectedNode = get_node(NodePath(params["node_name"]))
	else:
		selectedAnotherAnswer.emit(params)
		#selectedNode.remove_action_event()
		selectedNode = get_node(NodePath(params["node_name"]))
	
	
	pass
