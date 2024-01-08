extends Node

var current_scene_path: String = ""
var previous_scene_path: String = ""

func change_scene(new_scene_path: String):
    previous_scene_path = current_scene_path
    current_scene_path = new_scene_path
    get_tree().change_scene_to_file(new_scene_path)

func go_back():
    if previous_scene_path != "":
        change_scene(previous_scene_path)
