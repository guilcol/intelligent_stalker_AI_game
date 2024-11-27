extends Node2D

var map_paths: Array[String] = []
var curr_map_scene: Node2D = null
var curr_map_index: int = 0

func _ready() -> void:
	_get_all_map_paths()
	_open_map_at_index(curr_map_index)

func _open_map_at_index(index: int) -> void:
	if index >= 0 and index < len(map_paths):
		var map_path = map_paths[index]
		if curr_map_scene:
			remove_child(curr_map_scene)
		var map_scene_load = load(map_path)
		var map_scene_instance = map_scene_load.instantiate()
		curr_map_scene = map_scene_instance
		add_child(curr_map_scene)

func _get_all_map_paths() -> void:
	var path = "res://scenes/maps/"
	var dir = DirAccess.open(path)
	if dir:
		dir.list_dir_begin()
		var file_name = dir.get_next()
		while file_name != "":
			if not dir.current_is_dir():
				var map_path = path + file_name
				map_paths.append(map_path)
			file_name = dir.get_next()
