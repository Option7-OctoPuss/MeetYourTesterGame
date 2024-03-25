extends Node2D


@onready var popup_parent = $"../"
# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.
	


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func _on_skip_pressed():
	popup_parent.visible = false
	get_tree().change_scene_to_file("res://ui/menus/main_menu.tscn")


func _on_start_pressed():
	# should point to the tutorial
	get_tree().change_scene_to_file("res://ui/menus/tutorial_scene.tscn")
