extends Button

var progress_bar = null
var game_progress_bar = null
var zones_container = null

func _ready():
	# Called when the node enters the scene tree for the first time.
	var progress_frame_node = get_parent().get_node("ProgressBar").get_node("ProgressFrame")
	game_progress_bar = progress_frame_node.get_node("GameProgressBar")
	zones_container = progress_frame_node.get_node("ZonesContainer")
	# ZoneManager.zones_container = zones_container

const zone_dict_plus = {"offset": 10, "speedValue": 1.5, "length": 2}
const zone_dict_minus = {"offset": 10, "speedValue": 0.5, "length": 2}

func _on_Button_pressed_plus():
	game_progress_bar.value += 1

func _on_Button_pressed_minus():
	game_progress_bar.value -= 1

func _on_Button_pressed_zone_plus():
	print("zone plus")
	ZoneManager.create_zone(zone_dict_plus)

func _on_Button_pressed_zone_minus():
	print("zone minus")
	ZoneManager.create_zone(zone_dict_minus)
