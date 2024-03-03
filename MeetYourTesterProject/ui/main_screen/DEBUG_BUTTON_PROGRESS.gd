extends Button

# @onready var progress_bar = $ProgressBar.get_node("ProgressFrame").get_node("GameProgressBar")
@onready var progress_bar = get_parent().get_node("ProgressBar").get_node("ProgressFrame").get_node("GameProgressBar")
# Called when the node enters the scene tree for the first time.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func _on_Button_pressed_plus():
	progress_bar.value += 1

func _on_Button_pressed_minus():
	progress_bar.value -= 1