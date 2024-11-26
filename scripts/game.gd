extends Node2D

@onready var map: TileMapLayer = null
var preload_tile_node = preload("res://scenes/tile_node.tscn")
var preload_player = preload("res://scenes/player.tscn")
var preload_stalker = preload("res://scenes/stalker.tscn")

func _ready() -> void:
	_find_map_node()

func _find_map_node():
	var children = get_children()
	for child in children:
		if child is TileMapLayer:
			map = child
			break
