extends Button

const zone_dict_plus = {"offset": 10, "speedValue": 1.5, "length": 2}
const zone_dict_minus = {"offset": 10, "speedValue": 0.5, "length": 2}
var game_progress_bar = null
var anonimity_node = null

func _ready():
	game_progress_bar = get_parent().get_node("GameProgressBar")
	anonimity_node = get_parent().get_parent().get_node("AnonymityBarControl")
	if game_progress_bar == null:
		assert(false, "game_progress_bar is null")

func _on_Button_pressed_plus():
	game_progress_bar.value += 1

func _on_Button_pressed_minus():
	game_progress_bar.value -= 1

func _on_Debug_btn_pressed_plus():
	anonimity_node.add_anonymity_value(20)


func _on_Debug_btn_pressed_minus():
	anonimity_node.add_anonymity_value(-20)
